Return-Path: <linux-kernel-owner+w=401wt.eu-S964840AbXBTHy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbXBTHy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 02:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964866AbXBTHy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 02:54:29 -0500
Received: from wip-ec-wd.wipro.com ([203.91.193.32]:32888 "EHLO
	wip-ec-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964840AbXBTHy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 02:54:28 -0500
Subject: [KJ][PATCH] is_power_of_2 in fs/block_dev.c
From: Vignesh Babu BM <vignesh.babu@wipro.com>
To: Kernel Janitors List <kernel-janitors@lists.osdl.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Feb 2007 13:22:42 +0530
Message-Id: <1171957962.6127.67.camel@wriver-t81fb058.linuxcoe>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
X-OriginalArrivalTime: 20 Feb 2007 07:54:26.0372 (UTC) FILETIME=[579F2840:01C754C4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2


Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index fc7028b..e8f2a2b 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -22,6 +22,7 @@
 #include <linux/mount.h>
 #include <linux/uio.h>
 #include <linux/namei.h>
+#include <linux/log2.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -65,7 +66,7 @@ static void kill_bdev(struct block_device *bdev)
 int set_blocksize(struct block_device *bdev, int size)
 {
 	/* Size must be a power of two, and between 512 and PAGE_SIZE */
-	if (size > PAGE_SIZE || size < 512 || (size & (size-1)))
+	if (size > PAGE_SIZE || size < 512 || !is_power_of_2(size))
 		return -EINVAL;
 
 	/* Size cannot be smaller than the size supported by the device */

-- 
Regards,  
Vignesh Babu BM  
_____________________________________________________________  
"Why is it that every time I'm with you, makes me believe in magic?"
