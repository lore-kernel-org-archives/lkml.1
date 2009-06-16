Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbZFPTSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbZFPTSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZFPTRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:17:54 -0400
Received: from verein.lst.de ([213.95.11.210]:37580 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZFPTRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:17:53 -0400
Date: Tue, 16 Jun 2009 21:17:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hd: stop defining MAJOR_NR
Message-ID: <20090616191750.GA22726@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use HD_MAJOR directly.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/hd.c
===================================================================
--- linux-2.6.orig/drivers/block/hd.c	2009-06-11 20:54:27.184814475 +0200
+++ linux-2.6/drivers/block/hd.c	2009-06-16 21:16:19.716938868 +0200
@@ -100,8 +100,6 @@ static DEFINE_SPINLOCK(hd_lock);
 static struct request_queue *hd_queue;
 static struct request *hd_req;
 
-#define MAJOR_NR HD_MAJOR
-
 #define TIMEOUT_VALUE	(6*HZ)
 #define	HD_DELAY	0
 
@@ -712,12 +710,12 @@ static int __init hd_init(void)
 {
 	int drive;
 
-	if (register_blkdev(MAJOR_NR, "hd"))
+	if (register_blkdev(HD_MAJOR, "hd"))
 		return -1;
 
 	hd_queue = blk_init_queue(do_hd_request, &hd_lock);
 	if (!hd_queue) {
-		unregister_blkdev(MAJOR_NR, "hd");
+		unregister_blkdev(HD_MAJOR, "hd");
 		return -ENOMEM;
 	}
 
@@ -751,7 +749,7 @@ static int __init hd_init(void)
 		struct hd_i_struct *p = &hd_info[drive];
 		if (!disk)
 			goto Enomem;
-		disk->major = MAJOR_NR;
+		disk->major = HD_MAJOR;
 		disk->first_minor = drive << 6;
 		disk->fops = &hd_fops;
 		sprintf(disk->disk_name, "hd%c", 'a'+drive);
@@ -795,7 +793,7 @@ out1:
 	NR_HD = 0;
 out:
 	del_timer(&device_timer);
-	unregister_blkdev(MAJOR_NR, "hd");
+	unregister_blkdev(HD_MAJOR, "hd");
 	blk_cleanup_queue(hd_queue);
 	return -1;
 Enomem:
