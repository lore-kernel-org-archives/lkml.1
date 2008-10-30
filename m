Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbYJ3N5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbYJ3N5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 09:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYJ3NzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 09:55:14 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:42444 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbYJ3NzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 09:55:10 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Linus Torvalds <torvalds@osdl.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [RFC v8][PATCH 03/12] Make file_pos_read/write() public
Date: Thu, 30 Oct 2008 09:51:06 -0400
Message-Id: <1225374675-22850-4-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1225374675-22850-1-git-send-email-orenl@cs.columbia.edu>
References: <1225374675-22850-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two are needed when we will use vfs_read() and vfs_write(),
in the next patch.

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
 fs/read_write.c    |   10 ----------
 include/linux/fs.h |   10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 9ba495d..5d5c192 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -324,16 +324,6 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 
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
 asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
 {
 	struct file *file;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 580b513..5537435 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1296,6 +1296,16 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
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
1.5.4.3

