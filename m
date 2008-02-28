Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbYB1Grz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbYB1Grz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYB1Gpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:45:51 -0500
Received: from host106.paramount.wayport.net ([65.249.24.106]:52737 "EHLO
	honeydew.int.wil.cx" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754783AbYB1Gpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:45 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 01/12] Fix quota.h includes
Date: Thu, 28 Feb 2008 01:33:50 -0500
Message-Id: <1204180441-8540-1-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <20080227003605.GC5715@parisc-linux.org>
References: <20080227003605.GC5715@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

quota.h currently relies on asm/semaphore.h (through some chain; it
doesn't actually include semaphore.h itself) to include wait.h.  As
well as being bad practice to rely on an implicit include, subsequent
patches will break this.  While I'm in this file, add atomic.h and
list.h, and sort the list of includes.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/linux/quota.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/quota.h b/include/linux/quota.h
index 6e0393a..eb560d0 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -160,14 +160,18 @@ enum {
 
 
 #ifdef __KERNEL__
-#include <linux/spinlock.h>
-#include <linux/rwsem.h>
+#include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
 
 #include <linux/dqblk_xfs.h>
 #include <linux/dqblk_v1.h>
 #include <linux/dqblk_v2.h>
 
+#include <asm/atomic.h>
+
 extern spinlock_t dq_data_lock;
 
 /* Maximal numbers of writes for quota operation (insert/delete/update)
-- 
1.5.4.1

