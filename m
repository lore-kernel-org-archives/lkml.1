Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbYCAQTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbYCAQTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757734AbYCAQT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:19:26 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55576 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757401AbYCAQTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:19:25 -0500
Date: Sat, 1 Mar 2008 18:17:59 +0200
From: Adrian Bunk <bunk@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper prototype for blk_dev_init()
Message-ID: <20080301161759.GF25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper prototye for blk_dev_init() in block/blk.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 block/blk.h   |    2 ++
 block/genhd.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

4d1c0e77200be4790ad60d33cab6b4ed1956a71d foobar
diff --git a/block/blk.h b/block/blk.h
index ec898dd..ec9120f 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -32,6 +32,8 @@ void blk_recalc_rq_sectors(struct request *rq, int nsect);
 
 void blk_queue_congestion_threshold(struct request_queue *q);
 
+int blk_dev_init(void);
+
 /*
  * Return the threshold (number of used requests) at which the queue is
  * considered to be congested.  It include a little hysteresis to keep the
diff --git a/block/genhd.c b/block/genhd.c
index 53f2238..abc6fed 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -17,6 +17,8 @@
 #include <linux/buffer_head.h>
 #include <linux/mutex.h>
 
+#include "blk.h"
+
 static DEFINE_MUTEX(block_class_lock);
 #ifndef CONFIG_SYSFS_DEPRECATED
 struct kobject *block_depr;
@@ -346,8 +348,6 @@ const struct seq_operations partitions_op = {
 #endif
 
 
-extern int blk_dev_init(void);
-
 static struct kobject *base_probe(dev_t devt, int *part, void *data)
 {
 	if (request_module("block-major-%d-%d", MAJOR(devt), MINOR(devt)) > 0)

