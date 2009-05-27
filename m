Return-Path: <linux-kernel-owner+w=401wt.eu-S932823AbZE0SLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbZE0SLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762470AbZE0SL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:11:28 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:60068 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760981AbZE0SL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:11:27 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [RFC v16][PATCH 02/43] c/r: make file_pos_read/write() public
Date: Wed, 27 May 2009 13:32:28 -0400
Message-Id: <1243445589-32388-3-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu>
References: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
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
index 9d1e76b..ed63ea3 100644
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
index 3b534e5..9c4348a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1546,6 +1546,16 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
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

