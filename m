Return-Path: <linux-kernel-owner+w=401wt.eu-S1765059AbXKOQOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765059AbXKOQOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759664AbXKOQOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:14:37 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:15538 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758859AbXKOQOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:14:36 -0500
Date: Thu, 15 Nov 2007 19:13:50 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] proc: prototypes redux
Message-ID: <20071115161350.GG6216@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/generic.c  |   18 ++++++------------
 fs/proc/proc_tty.c |    3 ---
 2 files changed, 6 insertions(+), 15 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -25,12 +25,6 @@
 
 #include "internal.h"
 
-static ssize_t proc_file_read(struct file *file, char __user *buf,
-			      size_t nbytes, loff_t *ppos);
-static ssize_t proc_file_write(struct file *file, const char __user *buffer,
-			       size_t count, loff_t *ppos);
-static loff_t proc_file_lseek(struct file *, loff_t, int);
-
 DEFINE_SPINLOCK(proc_subdir_lock);
 
 static int proc_match(int len, const char *name, struct proc_dir_entry *de)
@@ -40,12 +34,6 @@ static int proc_match(int len, const char *name, struct proc_dir_entry *de)
 	return !memcmp(name, de->name, len);
 }
 
-static const struct file_operations proc_file_operations = {
-	.llseek		= proc_file_lseek,
-	.read		= proc_file_read,
-	.write		= proc_file_write,
-};
-
 /* buffer size is one page but our output routines use some slack for overruns */
 #define PROC_BLOCK_SIZE	(PAGE_SIZE - 1024)
 
@@ -233,6 +221,12 @@ proc_file_lseek(struct file *file, loff_t offset, int orig)
 	return retval;
 }
 
+static const struct file_operations proc_file_operations = {
+	.llseek		= proc_file_lseek,
+	.read		= proc_file_read,
+	.write		= proc_file_write,
+};
+
 static int proc_notify_change(struct dentry *dentry, struct iattr *iattr)
 {
 	struct inode *inode = dentry->d_inode;
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -15,9 +15,6 @@
 #include <linux/seq_file.h>
 #include <linux/bitops.h>
 
-static int tty_ldiscs_read_proc(char *page, char **start, off_t off,
-				int count, int *eof, void *data);
-
 /*
  * The /proc/tty directory inodes...
  */

