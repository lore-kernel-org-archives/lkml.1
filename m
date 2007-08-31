Return-Path: <linux-kernel-owner+w=401wt.eu-S1762374AbXHaWme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762374AbXHaWme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 18:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbXHaWmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 18:42:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbXHaWmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 18:42:23 -0400
Date: Fri, 31 Aug 2007 18:41:46 -0400 (EDT)
Message-Id: <20070831.184146.18307878.k-ueda@ct.jp.nec.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, jens.axboe@oracle.com, mike.miller@hp.com,
       grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 2/7] blk_end_request: add blk_rq_size() macros
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds macros to get the size of request in bytes.
They are useful because blk_end_request() takes bytes
as a completed I/O size instead of sectors.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 blkdev.h |    9 +++++++++
 1 files changed, 9 insertions(+)

diff -rupN 01-blkendreq-interface/include/linux/blkdev.h 02-sect2byte-macro/include/linux/blkdev.h
--- 01-blkendreq-interface/include/linux/blkdev.h	2007-08-23 17:22:50.000000000 -0400
+++ 02-sect2byte-macro/include/linux/blkdev.h	2007-08-23 17:25:59.000000000 -0400
@@ -737,6 +737,15 @@ extern void end_request(struct request *
 extern void blk_complete_request(struct request *);
 
 /*
+ * blk_end_request() takes bytes instead of sectors as a complete size.
+ * blk_rq_size() returns the entire size left to complete in the request.
+ * blk_rq_cur_size() returns the size left to complete in the current segment.
+ */
+#define sect2byte(nr_sectors) ((nr_sectors) << 9)
+#define blk_rq_size(rq) (sect2byte((rq)->hard_nr_sectors))
+#define blk_rq_cur_size(rq) (sect2byte((rq)->current_nr_sectors))
+
+/*
  * end_that_request_first/chunk() takes an uptodate argument. we account
  * any value <= as an io error. 0 means -EIO for compatability reasons,
  * any other < 0 value is the direct error type. An uptodate value of
