Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZLNAUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZLNAUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbZLNATs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:19:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34095 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867AbZLMX5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:41 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, jens.axboe@oracle.com, tj@kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: [PATCH 3/3] Constify struct block_device_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:22 +0100
Message-Id: <c1fac38d462d0b325ed4d5f59f6ab1b3470bc38a.1260662995.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662995.git.re.emese@gmail.com>
References: <cover.1260662995.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/linux/blkdev.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 784a919..ec674e7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1283,19 +1283,19 @@ static inline int blk_integrity_rq(struct request *rq)
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
+	struct module * const owner;
 };
 
 extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
-- 
1.6.5.3

