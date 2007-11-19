Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbXKSWJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbXKSWJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbXKSWHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:07:21 -0500
Received: from palrel10.hp.com ([156.153.255.245]:45332 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805AbXKSWHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:07:19 -0500
Date: Mon, 19 Nov 2007 16:07:17 -0600
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/3] cciss: add support for blktrace
Message-ID: <20071119220717.GB4660@roadking.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 2 of 3
This patch adds support for the blktrace utility. Please consider this for
inclusion. Seems there was already a call to blk_add_trace. This patch adds
ifdef's and includes the header file.

Signed-off-by: Mike Miller <mike.miller@hp.com>


diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 2ba5a89..61bc0f3 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -41,6 +41,10 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+#include <linux/blktrace_api.h>
+#endif /* CONFIG_BLK_DEV_IO_TRACE */
+
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
@@ -3013,7 +3017,9 @@ after_error_processing:
 	}
 	cmd->rq->data_len = 0;
 	cmd->rq->completion_data = cmd;
+#ifdef CONFIG_BLK_DEV_IO_TRACE
 	blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
+#endif /* CONFIG_BLK_DEV_IO_TRACE */
 	blk_complete_request(cmd->rq);
 }
 
