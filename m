Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab0CAJqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:46:09 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:54609 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943Ab0CAJqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:46:07 -0500
Subject: [PATCH] cfq: remove 8 bytes of padding from cfq_rb_root on 64 bit
 builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 09:46:05 +0000
Message-ID: <1267436765.2127.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder cfq_rb_root to remove 8 bytes of padding on 64 bit builds.
    

Consequently removing 56 bytes from cfq_group and 64 bytes from
cfq_data.
    
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---
patch against 2.6.33
compiled & tested on x86_64 AMD-X2

regards
Richard

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e3dedfd..daff53d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -77,11 +77,12 @@ struct cfq_rb_root {
 	struct rb_root rb;
 	struct rb_node *left;
 	unsigned count;
+	unsigned total_weight;
 	u64 min_vdisktime;
 	struct rb_node *active;
-	unsigned total_weight;
 };
-#define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, 0, 0, }
+#define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
+			.count = 0, .min_vdisktime = 0, }
 
 /*
  * Per process-grouping structure


