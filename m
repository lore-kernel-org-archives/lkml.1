Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZIWX6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZIWX6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZIWX57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:57:59 -0400
Received: from smtp231.iad.emailsrvr.com ([207.97.245.231]:34745 "EHLO
	smtp231.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZIWX54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:57:56 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2009 19:57:55 EDT
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Oren Laadan <orenl@librato.com>, Oren Laadan <orenl@cs.columbia.edu>
Subject: [PATCH v18 10/80] c/r: make file_pos_read/write() public
Date: Wed, 23 Sep 2009 19:50:50 -0400
Message-Id: <1253749920-18673-11-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253749920-18673-1-git-send-email-orenl@librato.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two are used in the next patch when calling vfs_read/write()

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
 fs/read_write.c    |   10 ----------
 include/linux/fs.h |   10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 6c8c55d..d331975 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -359,16 +359,6 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 
 EXPORT_SYMBOL(vfs_write);
 
-static inline loff_t file_pos_read(struct file *file)
-{
-	return file->f_pos;
-}
-
-static inline void file_pos_write(struct file *file, loff_t pos)
-{
-	file->f_pos = pos;
-}
-
 SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
 {
 	struct file *file;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 73e9b64..a21f175 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1548,6 +1548,16 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 				struct iovec *fast_pointer,
 				struct iovec **ret_pointer);
 
+static inline loff_t file_pos_read(struct file *file)
+{
+	return file->f_pos;
+}
+
+static inline void file_pos_write(struct file *file, loff_t pos)
+{
+	file->f_pos = pos;
+}
+
 extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
-- 
1.6.0.4

