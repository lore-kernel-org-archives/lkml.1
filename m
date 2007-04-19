Return-Path: <linux-kernel-owner+w=401wt.eu-S1030839AbXDSENi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030839AbXDSENi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 00:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031102AbXDSENh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 00:13:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:38954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030839AbXDSENg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 00:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Zgo2N+54P81I3+Tp1dOjq/lloTil+n71KfbbeGJ6NqCGOdCL7VFzmbX3hWcXlpS2HmEqtddkd+eZw/Ijm7jMTEYIqq7NvJQPJIKgSePDmnAuKtOLSQyO/Z1swR3GrzuzR8LUg+iQiyn5qHZAHPImisKnesJ++qgjzzaCJdOV5RY=
Date: Thu, 19 Apr 2007 09:45:59 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: Kernel Janitors <kernel-janitors@lists.osdl.org>,
       S390 <linux-s390@vger.kernel.org>
Cc: Andrw Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [KJ][PATCH]SPIN_LOCK_UNLOCKED cleanup in drivers/s390
Message-ID: <20070419041440.GB14283@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead.
 
Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 char/vmlogrdr.c |    6 +++---
 cio/cmf.c       |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index b87d3b0..75d61a4 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -125,7 +125,7 @@ static struct vmlogrdr_priv_t sys_ser[] = {
 	  .recording_name = "EREP",
 	  .minor_num      = 0,
 	  .buffer_free    = 1,
-	  .priv_lock      = SPIN_LOCK_UNLOCKED,
+	  .priv_lock      = __SPIN_LOCK_UNLOCKED(sys_ser[0].priv_lock),
 	  .autorecording  = 1,
 	  .autopurge      = 1,
 	},
@@ -134,7 +134,7 @@ static struct vmlogrdr_priv_t sys_ser[] = {
 	  .recording_name = "ACCOUNT",
 	  .minor_num      = 1,
 	  .buffer_free    = 1,
-	  .priv_lock      = SPIN_LOCK_UNLOCKED,
+	  .priv_lock      = __SPIN_LOCK_UNLOCKED(sys_ser[1].priv_lock),
 	  .autorecording  = 1,
 	  .autopurge      = 1,
 	},
@@ -143,7 +143,7 @@ static struct vmlogrdr_priv_t sys_ser[] = {
 	  .recording_name = "SYMPTOM",
 	  .minor_num      = 2,
 	  .buffer_free    = 1,
-	  .priv_lock      = SPIN_LOCK_UNLOCKED,
+	  .priv_lock      = __SPIN_LOCK_UNLOCKED(sys_ser[2].priv_lock),
 	  .autorecording  = 1,
 	  .autopurge      = 1,
 	}
diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index 90b22fa..28abd69 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -476,7 +476,7 @@ struct cmb_area {
 };
 
 static struct cmb_area cmb_area = {
-	.lock = SPIN_LOCK_UNLOCKED,
+	.lock = __SPIN_LOCK_UNLOCKED(cmb_area.lock),
 	.list = LIST_HEAD_INIT(cmb_area.list),
 	.num_channels  = 1024,
 };
-- 
Milind Arun Choudhary
