Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbYEESm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbYEESm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761602AbYEESah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:30:37 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55295 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760109AbYEESag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:30:36 -0400
Date: Mon, 5 May 2008 21:29:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] move proc_kmsg_operations to fs/proc/internal.h
Message-ID: <20080505182928.GX17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the extern of struct proc_kmsg_operations to 
fs/proc/internal.h and adds an #include "internal.h" to fs/proc/kmsg.c 
so that the latter sees the former.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 23 Apr 2008

 fs/proc/internal.h      |    1 +
 fs/proc/kmsg.c          |    2 ++
 include/linux/proc_fs.h |    1 -
 3 files changed, 3 insertions(+), 1 deletion(-)

--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -65,6 +65,7 @@ extern const struct file_operations proc_smaps_operations;
 extern const struct file_operations proc_clear_refs_operations;
 extern const struct file_operations proc_pagemap_operations;
 extern const struct file_operations proc_net_operations;
+extern const struct file_operations proc_kmsg_operations;
 extern const struct inode_operations proc_net_inode_operations;
 
 void free_proc_entry(struct proc_dir_entry *de);
diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
index ff3b90b..9fd5df3 100644
--- a/fs/proc/kmsg.c
+++ b/fs/proc/kmsg.c
@@ -15,6 +15,8 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#include "internal.h"
+
 extern wait_queue_head_t log_wait;
 
 extern int do_syslog(int type, char __user *bug, int count);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 9b6c935..5887e25 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -144,7 +144,6 @@ extern int proc_readdir(struct file *, void *, filldir_t);
 extern struct dentry *proc_lookup(struct inode *, struct dentry *, struct nameidata *);
 
 extern const struct file_operations proc_kcore_operations;
-extern const struct file_operations proc_kmsg_operations;
 extern const struct file_operations ppc_htab_operations;
 
 extern int pid_ns_prepare_proc(struct pid_namespace *ns);

