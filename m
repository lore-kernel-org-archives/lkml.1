Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZLDWKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZLDWKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZLDWKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:10:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32789 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbZLDWKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:10:05 -0500
Message-ID: <4B198930.8000600@gmail.com>
Date: Fri, 04 Dec 2009 23:12:00 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: gregkh@suse.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 04/31] Constify struct block_device_operations for 2.6.32
 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct block_device_operations.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/staging/dst/dcore.c     |    2 +-
 drivers/staging/hv/blkvsc_drv.c |    2 +-
 include/linux/blkdev.h          |   22 +++++++++++-----------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/dst/dcore.c b/drivers/staging/dst/dcore.c
index c24e4e0..4f62b69 100644
--- a/drivers/staging/dst/dcore.c
+++ b/drivers/staging/dst/dcore.c
@@ -149,7 +149,7 @@ static int dst_bdev_release(struct gendisk *disk, fmode_t mode)
 	return 0;
 }
 
-static struct block_device_operations dst_blk_ops = {
+static const struct block_device_operations dst_blk_ops = {
 	.open		= dst_bdev_open,
 	.release	= dst_bdev_release,
 	.owner		= THIS_MODULE,
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 62b2828..0a47695 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -153,7 +153,7 @@ static int blkvsc_ringbuffer_size = BLKVSC_RING_BUFFER_SIZE;
 /* The one and only one */
 static struct blkvsc_driver_context g_blkvsc_drv;
 
-static struct block_device_operations block_ops = {
+static const struct block_device_operations block_ops = {
 	.owner = THIS_MODULE,
 	.open = blkvsc_open,
 	.release = blkvsc_release,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 221cecd..82f20f0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1253,19 +1253,19 @@ static inline int blk_integrity_rq(struct request *rq)
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
 struct block_device_operations {
-	int (*open) (struct block_device *, fmode_t);
-	int (*release) (struct gendisk *, fmode_t);
-	int (*locked_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	int (*direct_access) (struct block_device *, sector_t,
+	int (* const open) (struct block_device *, fmode_t);
+	int (* const release) (struct gendisk *, fmode_t);
+	int (* const locked_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
+	int (* const ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
+	int (* const compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
+	int (* const direct_access) (struct block_device *, sector_t,
 						void **, unsigned long *);
-	int (*media_changed) (struct gendisk *);
-	unsigned long long (*set_capacity) (struct gendisk *,
+	int (* const media_changed) (struct gendisk *);
+	unsigned long long (* const set_capacity) (struct gendisk *,
 						unsigned long long);
-	int (*revalidate_disk) (struct gendisk *);
-	int (*getgeo)(struct block_device *, struct hd_geometry *);
-	struct module *owner;
+	int (* const revalidate_disk) (struct gendisk *);
+	int (*const getgeo)(struct block_device *, struct hd_geometry *);
+	const struct module *owner;
 };
 
 extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,

