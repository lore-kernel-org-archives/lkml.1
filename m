Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbYDWJ41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbYDWJ41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbYDWJvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:51:46 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36875 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbYDWJvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:51:43 -0400
Date: Wed, 23 Apr 2008 12:51:04 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] move proc_kmsg_operations to fs/proc/internal.h
Message-ID: <20080423095104.GW28933@cs181133002.pp.htv.fi>
References: <20080421213209.GN2633@cs181133002.pp.htv.fi> <20080421224314.GA963@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080421224314.GA963@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 02:43:14AM +0400, Alexey Dobriyan wrote:
> On Tue, Apr 22, 2008 at 12:32:09AM +0300, Adrian Bunk wrote:
> > Every file should include the headers containing the externs its global 
> > code.
> 
> Declaration should be moved to fs/proc/internal.h and included from
> there.

Updated patch below.

> > --- a/fs/proc/kmsg.c
> > +++ b/fs/proc/kmsg.c
> > @@ -11,6 +11,7 @@
> >  #include <linux/kernel.h>
> >  #include <linux/poll.h>
> >  #include <linux/fs.h>
> > +#include <linux/proc_fs.h>
> 
> No, really. Such included tend to stick forever, so let's do right thing
> from beginning.
> 
> It would be nice if your scripts put at least some names of
> relevant globals into changelog.

No scripts were involved in the creation and/or sending of this
patch - all problems are 100% human errors.  ;)

cu
Adrian


<--  snip  -->


This patch moves the extern of struct proc_kmsg_operations to 
fs/proc/internal.h and adds an #include "internal.h" to fs/proc/kmsg.c 
so that the latter sees the former.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

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

