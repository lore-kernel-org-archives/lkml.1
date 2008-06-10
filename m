Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYFJD0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYFJD0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 23:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYFJD0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 23:26:37 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:60885
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266AbYFJD0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 23:26:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmcBALp1TUh8qNvt/2dsb2JhbAAIsC4
X-IronPort-AV: E=Sophos;i="4.27,615,1204470000"; 
   d="scan'208";a="275379548"
Subject: [PATCH] Move struct mm_struct forward-declaration in proc_fs,h
From: Ben Nizette <bn@niasdigital.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Nias Digital
Date: Tue, 10 Jun 2008 13:26:32 +1000
Message-Id: <1213068392.3213.33.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the forward-declaration of struct mm_struct a little way up
proc_fs.h.  This fixes a bunch of "'struct mm_struct' declared inside
parameter list" warnings with CONFIG_PROC_FS=n

Signed-off-by: Ben Nizette <bn@niasdigital.com>

---
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 9883bc9..fff1d27 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -9,6 +9,8 @@
 
 struct net;
 struct completion;
+struct mm_struct;
+
 /*
  * The proc filesystem constants/structures
  */
@@ -101,8 +103,6 @@ extern spinlock_t proc_subdir_lock;
 extern void proc_root_init(void);
 extern void proc_misc_init(void);
 
-struct mm_struct;
-
 void proc_flush_task(struct task_struct *task);
 struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *);
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);

