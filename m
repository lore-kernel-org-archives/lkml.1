Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZA0RLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZA0RLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbZA0RJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:09:27 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:57677 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbZA0RJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:09:23 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Serge Hallyn <serue@us.ibm.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [RFC v13][PATCH 03/14] Make file_pos_read/write() public
Date: Tue, 27 Jan 2009 12:08:01 -0500
Message-Id: <1233076092-8660-4-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two are used in the next patch when calling vfs_read/write()
---
 fs/read_write.c    |   10 ----------
 include/linux/fs.h |   10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 969a6d9..dda4eab 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -346,16 +346,6 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 
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
index 4a853ef..39a54b9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1344,6 +1344,16 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
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

