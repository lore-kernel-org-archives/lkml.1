Return-Path: <linux-kernel-owner+w=401wt.eu-S1764173AbXHaWrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764173AbXHaWrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 18:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932123AbXHaWq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 18:46:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763109AbXHaWqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 18:46:24 -0400
Date: Fri, 31 Aug 2007 18:46:16 -0400 (EDT)
Message-Id: <20070831.184616.111210109.k-ueda@ct.jp.nec.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, jens.axboe@oracle.com
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [APPENDIX PATCH 5/5] blk_end_request: userspace multipath-tools
 for request-based dm
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes multipath-tools to use request-based dm-multipath.
This patch should be applied on top of 8/28/2007 git multipath-tools.

Request-based dm itself is still under development and not ready
for inclusion.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 devmapper.c |    2 ++
 1 files changed, 2 insertions(+)

diff -rupN git-multipath-tools-20070828/libmultipath/devmapper.c rqdm-multipath-tools/libmultipath/devmapper.c
--- git-multipath-tools-20070828/libmultipath/devmapper.c	2007-08-28 17:05:25.000000000 -0400
+++ rqdm-multipath-tools/libmultipath/devmapper.c	2007-08-28 17:50:47.000000000 -0400
@@ -174,6 +174,7 @@ dm_simplecmd (int task, const char *name
 #ifdef LIBDM_API_FLUSH
 	dm_task_no_flush(dmt);          /* for DM_DEVICE_SUSPEND/RESUME */
 #endif
+	dm_task_request_base(dmt);
 
 	r = dm_task_run (dmt);
 
@@ -211,6 +212,7 @@ dm_addmap (int task, const char *name, c
 	}
 
 	dm_task_no_open_count(dmt);
+	dm_task_request_base(dmt);
 
 	r = dm_task_run (dmt);
 
