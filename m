Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbXGHTLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbXGHTLd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 15:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbXGHTL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 15:11:26 -0400
Received: from smtp.xtech.com.ar ([200.68.115.49]:2464 "EHLO smtp.xtech.com.ar"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbXGHTLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 15:11:25 -0400
Date: Sun, 8 Jul 2007 16:11:23 -0300
From: Diego Woitasen <diego@woitasen.com.ar>
To: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Remove unneded lock_kernel() in drivers/block/loop.c
Message-ID: <20070708191123.GA466@motherbox.xtechq.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Bogosity: No, tests=bogofilter, spamicity=0.000000, version=0.94.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch remove the unneeded lock_kernel() in drivers/block/loop.c. I
read the code and this lock_kernel() doesn't protect anything. Loopback
code use lo_ctl_mutex for syncronization.

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 0ed5470..1cc004e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1286,7 +1286,6 @@ static long lo_compat_ioctl(struct file *file, unsigned int cmd, unsigned long a
 	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
 	int err;
 
-	lock_kernel();
 	switch(cmd) {
 	case LOOP_SET_STATUS:
 		mutex_lock(&lo->lo_ctl_mutex);
@@ -1312,7 +1311,6 @@ static long lo_compat_ioctl(struct file *file, unsigned int cmd, unsigned long a
 		err = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
 	return err;
 }
 #endif


-- 

--------------
Diego Woitasen
