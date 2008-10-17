Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYJQMwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYJQMwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbYJQMvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:51:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:4884 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467AbYJQMve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=c9lMZOTo4YVGLxEsdZjpUAu4DLKdfwmXMbxzsjSn/Y7ATsXUHVq70wKkguNQHULHx9
         Fyybyzza19JO76buzARZ+NCFi8WLLWMOHb47qH9x2IQdiAuzrHBsmFnzeMlt9GfRoNtn
         hlLQqQ+kXaOIVrsZoElUmelqwBl+9gKWJJppw=
Date: Fri, 17 Oct 2008 16:54:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 31/31] proc: remove fs/proc/proc_misc.c
Message-ID: <20081017125437.GF22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 1622821da166f6d282b383e0cd722c6ca3ead1c6 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 14:49:39 +0400
Subject: [PATCH 31/31] proc: remove fs/proc/proc_misc.c

Now that everything was moved to their more or less expected places,
apply rm(1).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/Makefile        |    2 +-
 fs/proc/proc_misc.c     |   64 -----------------------------------------------
 fs/proc/root.c          |    2 +-
 include/linux/proc_fs.h |    1 -
 4 files changed, 2 insertions(+), 67 deletions(-)
 delete mode 100644 fs/proc/proc_misc.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index fef5244..63d9651 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -8,7 +8,7 @@ proc-y			:= nommu.o task_nommu.o
 proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 
 proc-y       += inode.o root.o base.o generic.o array.o \
-		proc_tty.o proc_misc.o
+		proc_tty.o
 proc-y	+= cmdline.o
 proc-y	+= cpuinfo.o
 proc-y	+= devices.o
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
deleted file mode 100644
index b0d3b34..0000000
--- a/fs/proc/proc_misc.c
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- *  linux/fs/proc/proc_misc.c
- *
- *  linux/fs/proc/array.c
- *  Copyright (C) 1992  by Linus Torvalds
- *  based on ideas by Darren Senn
- *
- *  This used to be the part of array.c. See the rest of history and credits
- *  there. I took this into a separate file and switched the thing to generic
- *  proc_file_inode_operations, leaving in array.c only per-process stuff.
- *  Inumbers allocation made dynamic (via create_proc_entry()).  AV, May 1999.
- *
- * Changes:
- * Fulton Green      :  Encapsulated position metric calculations.
- *			<kernel@FultonGreen.com>
- */
-
-#include <linux/types.h>
-#include <linux/errno.h>
-#include <linux/time.h>
-#include <linux/kernel.h>
-#include <linux/kernel_stat.h>
-#include <linux/fs.h>
-#include <linux/tty.h>
-#include <linux/string.h>
-#include <linux/mman.h>
-#include <linux/quicklist.h>
-#include <linux/proc_fs.h>
-#include <linux/ioport.h>
-#include <linux/mm.h>
-#include <linux/mmzone.h>
-#include <linux/pagemap.h>
-#include <linux/interrupt.h>
-#include <linux/swap.h>
-#include <linux/slab.h>
-#include <linux/genhd.h>
-#include <linux/smp.h>
-#include <linux/signal.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/seq_file.h>
-#include <linux/times.h>
-#include <linux/profile.h>
-#include <linux/utsname.h>
-#include <linux/blkdev.h>
-#include <linux/hugetlb.h>
-#include <linux/jiffies.h>
-#include <linux/vmalloc.h>
-#include <linux/crash_dump.h>
-#include <linux/pid_namespace.h>
-#include <linux/bootmem.h>
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-#include <asm/io.h>
-#include <asm/tlb.h>
-#include <asm/div64.h>
-#include "internal.h"
-
-void __init proc_misc_init(void)
-{
-	proc_symlink("mounts", NULL, "self/mounts");
-
-	/* And now for trickier ones */
-}
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 2a3abd2..7761602 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -117,7 +117,7 @@ void __init proc_root_init(void)
 		return;
 	}
 
-	proc_misc_init();
+	proc_symlink("mounts", NULL, "self/mounts");
 
 	proc_net_init();
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 9d83089..b8bdb96 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -100,7 +100,6 @@ struct vmcore {
 extern spinlock_t proc_subdir_lock;
 
 extern void proc_root_init(void);
-extern void proc_misc_init(void);
 
 void proc_flush_task(struct task_struct *task);
 struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *);
-- 
1.5.6.5

