Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYDWTM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYDWTM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 15:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbYDWTMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 15:12:19 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:1646 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYDWTMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 15:12:18 -0400
Message-ID: <480F8A0E.8070206@hp.com>
Date: Wed, 23 Apr 2008 15:12:14 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH 1/3] Add flag and sysfs interfaces
References: <480F8936.5030406@hp.com>
In-Reply-To: <480F8936.5030406@hp.com>
Content-Type: multipart/mixed;
 boundary="------------090103020303000008050705"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090103020303000008050705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------090103020303000008050705
Content-Type: text/x-patch;
 name="0001-Added-QUEUE_FLAG_NOMERGES-and-sysfs-interfaces.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Added-QUEUE_FLAG_NOMERGES-and-sysfs-interfaces.patch"


Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 block/blk-sysfs.c      |   27 +++++++++++++++++++++++++++
 include/linux/blkdev.h |    2 ++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 54d0db1..32d917c 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -135,6 +135,26 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
+{
+	int nm = test_bit(QUEUE_FLAG_NOMERGES, &q->queue_flags);
+	return queue_var_show(nm, page);
+}
+
+static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
+				    size_t count)
+{
+	unsigned long nm;
+	ssize_t ret = queue_var_store(&nm, page, count);
+
+	if (nm)
+	       set_bit(QUEUE_FLAG_NOMERGES, &q->queue_flags);
+	else
+	       clear_bit(QUEUE_FLAG_NOMERGES, &q->queue_flags);
+
+	return ret;
+}
+
 
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
@@ -170,6 +190,12 @@ static struct queue_sysfs_entry queue_hw_sector_size_entry = {
 	.show = queue_hw_sector_size_show,
 };
 
+static struct queue_sysfs_entry queue_nomerges_entry = {
+	.attr = {.name = "nomerges", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_nomerges_show,
+	.store = queue_nomerges_store,
+};
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -177,6 +203,7 @@ static struct attribute *default_attrs[] = {
 	&queue_max_sectors_entry.attr,
 	&queue_iosched_entry.attr,
 	&queue_hw_sector_size_entry.attr,
+	&queue_nomerges_entry.attr,
 	NULL,
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6f79d40..ee577f9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -405,6 +405,7 @@ struct request_queue
 #define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
 #define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
+#define QUEUE_FLAG_NOMERGES    10	/* disable merge attempts */
 
 enum {
 	/*
@@ -449,6 +450,7 @@ enum {
 #define blk_queue_plugged(q)	test_bit(QUEUE_FLAG_PLUGGED, &(q)->queue_flags)
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
+#define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_flushing(q)	((q)->ordseq)
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
-- 
1.5.2.5


--------------090103020303000008050705--
