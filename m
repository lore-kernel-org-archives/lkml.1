Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbXD0OJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbXD0OJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbXD0OH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:07:28 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:33942 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbXD0OFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:05:04 -0400
Message-Id: <20070427140520.859093636@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Apr 2007 16:05:41 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Milind Arun Choudhary <milindchoudhary@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 38/38] SPIN_LOCK_UNLOCKED cleanup in drivers/s390
Content-Disposition: inline; filename=141-spinlock.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milind Arun Choudhary <milindchoudhary@gmail.com>

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead.

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/vmlogrdr.c |    6 +++---
 drivers/s390/cio/cmf.c       |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: quilt-2.6/drivers/s390/char/vmlogrdr.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/vmlogrdr.c	2007-04-27 16:04:59.000000000 +0200
+++ quilt-2.6/drivers/s390/char/vmlogrdr.c	2007-04-27 16:05:02.000000000 +0200
@@ -125,7 +125,7 @@
 	  .recording_name = "EREP",
 	  .minor_num      = 0,
 	  .buffer_free    = 1,
-	  .priv_lock      = SPIN_LOCK_UNLOCKED,
+	  .priv_lock	  = __SPIN_LOCK_UNLOCKED(sys_ser[0].priv_lock),
 	  .autorecording  = 1,
 	  .autopurge      = 1,
 	},
@@ -134,7 +134,7 @@
 	  .recording_name = "ACCOUNT",
 	  .minor_num      = 1,
 	  .buffer_free    = 1,
-	  .priv_lock      = SPIN_LOCK_UNLOCKED,
+	  .priv_lock	  = __SPIN_LOCK_UNLOCKED(sys_ser[1].priv_lock),
 	  .autorecording  = 1,
 	  .autopurge      = 1,
 	},
@@ -143,7 +143,7 @@
 	  .recording_name = "SYMPTOM",
 	  .minor_num      = 2,
 	  .buffer_free    = 1,
-	  .priv_lock      = SPIN_LOCK_UNLOCKED,
+	  .priv_lock	  = __SPIN_LOCK_UNLOCKED(sys_ser[2].priv_lock),
 	  .autorecording  = 1,
 	  .autopurge      = 1,
 	}
Index: quilt-2.6/drivers/s390/cio/cmf.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/cmf.c	2007-04-27 16:01:49.000000000 +0200
+++ quilt-2.6/drivers/s390/cio/cmf.c	2007-04-27 16:05:02.000000000 +0200
@@ -476,7 +476,7 @@
 };
 
 static struct cmb_area cmb_area = {
-	.lock = SPIN_LOCK_UNLOCKED,
+	.lock = __SPIN_LOCK_UNLOCKED(cmb_area.lock),
 	.list = LIST_HEAD_INIT(cmb_area.list),
 	.num_channels  = 1024,
 };

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

