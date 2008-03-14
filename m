Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbYCNVNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbYCNVNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYCNVNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:13:35 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:38734 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYCNVNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:13:34 -0400
X-Greylist: delayed 1695 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2008 17:13:34 EDT
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, lenb@kernel.org,
       dhowells@redhat.com, peterz@infradead.org, mingo@elte.hu,
       harvey.harrison@gmail.com
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/6] Fix quota.h includes
Date: Fri, 14 Mar 2008 16:44:48 -0400
Message-Id: <1205527493-5740-1-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080314204248.GV613@parisc-linux.org>
References: <20080314204248.GV613@parisc-linux.org>
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
1.5.4.3

