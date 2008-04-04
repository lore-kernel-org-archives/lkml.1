Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbYDDV2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbYDDV2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYDDV2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:28:08 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:10328 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbYDDV2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:28:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YKtNU4nG3rb2b+zaI/1tR9AGIl5mj6QwamPCjk1U8U4eKy7VV8n++UGTHpTEnLhOAdBA3d5/eFi9RqhgsspwYE4xv8x8e0uruFSm4v4C5AUpU9KAA0y6sZ4P6vYVVKByS8aOpEWKB4WN0hnyGXyfGkF9WcrbKuUhECViORFwbss=
Subject: [PATCH 1/2] ocfs2: replace remaining __PRETTY_FUNCTION__
	occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mark Fasheh <mfasheh@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 14:28:00 -0700
Message-Id: <1207344480.18838.96.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel is written in C, not C++, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ocfs2/cluster/masklog.h |    2 +-
 fs/ocfs2/dlmglue.c         |    2 +-
 fs/ocfs2/super.h           |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 597e064..8bdb182 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -193,7 +193,7 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
  */
 #define __mlog_printk(level, fmt, args...)				\
 	printk(level "(%u,%lu):%s:%d " fmt, task_pid_nr(current),	\
-	       __mlog_cpu_guess, __PRETTY_FUNCTION__, __LINE__ ,	\
+	       __mlog_cpu_guess, __func__, __LINE__ ,	\
 	       ##args)
 
 #define mlog(mask, fmt, args...) do {					\
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 1f1873b..5a3f1f4 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -105,7 +105,7 @@ static void ocfs2_dentry_post_unlock(struct ocfs2_super *osb,
 				     struct ocfs2_lock_res *lockres);
 

-#define mlog_meta_lvb(__level, __lockres) ocfs2_dump_meta_lvb_info(__level, __PRETTY_FUNCTION__, __LINE__, __lockres)
+#define mlog_meta_lvb(__level, __lockres) ocfs2_dump_meta_lvb_info(__level, __func__, __LINE__, __lockres)
 
 /* This aids in debugging situations where a bad LVB might be involved. */
 static void ocfs2_dump_meta_lvb_info(u64 level,
diff --git a/fs/ocfs2/super.h b/fs/ocfs2/super.h
index 783f527..15e2d98 100644
--- a/fs/ocfs2/super.h
+++ b/fs/ocfs2/super.h
@@ -36,13 +36,13 @@ void __ocfs2_error(struct super_block *sb,
 		   const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 
-#define ocfs2_error(sb, fmt, args...) __ocfs2_error(sb, __PRETTY_FUNCTION__, fmt, ##args)
+#define ocfs2_error(sb, fmt, args...) __ocfs2_error(sb, __func__, fmt, ##args)
 
 void __ocfs2_abort(struct super_block *sb,
 		   const char *function,
 		   const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 
-#define ocfs2_abort(sb, fmt, args...) __ocfs2_abort(sb, __PRETTY_FUNCTION__, fmt, ##args)
+#define ocfs2_abort(sb, fmt, args...) __ocfs2_abort(sb, __func__, fmt, ##args)
 
 #endif /* OCFS2_SUPER_H */
-- 
1.5.5.rc1.135.g8527


