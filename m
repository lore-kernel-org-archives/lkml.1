Return-Path: <linux-kernel-owner+w=401wt.eu-S1767167AbXEBWxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767167AbXEBWxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767168AbXEBWxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:53:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48211 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767167AbXEBWxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:53:31 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: jack@suse.cz
Subject: [patch] hide spinlock in linux/quota.h behind __KERNEL__
Date: Wed, 2 May 2007 18:53:39 -0400
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021853.39952.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 77db80a..6243982 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -44,8 +44,6 @@
 typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
 typedef __u64 qsize_t;          /* Type in which we store sizes */
 
-extern spinlock_t dq_data_lock;
-
 /* Size of blocks in which are counted size limits */
 #define QUOTABLOCK_BITS 10
 #define QUOTABLOCK_SIZE (1 << QUOTABLOCK_BITS)
@@ -139,6 +137,8 @@ struct if_dqinfo {
 #include <linux/dqblk_v1.h>
 #include <linux/dqblk_v2.h>
 
+extern spinlock_t dq_data_lock;
+
 /* Maximal numbers of writes for quota operation (insert/delete/update)
  * (over VFS all formats) */
 #define DQUOT_INIT_ALLOC max(V1_INIT_ALLOC, V2_INIT_ALLOC)
