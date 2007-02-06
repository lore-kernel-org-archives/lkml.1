Return-Path: <linux-kernel-owner+w=401wt.eu-S965587AbXBFWOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965587AbXBFWOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965580AbXBFWN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:13:28 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39728 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965571AbXBFWMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:12:54 -0500
Date: Tue, 6 Feb 2007 23:12:58 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] fs/proc/: make code static
Message-ID: <20070206221258.GK27397@stusta.de>
References: <20070127234928.64d8e437.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 11:49:28PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc4-mm1:
>...
> +sysctl-reimplement-the-sysctl-proc-support.patch
>...
>  A few sysctl patches.
>...


proc_match() and struct proc_sys_root can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/proc/generic.c       |    2 +-
 fs/proc/proc_sysctl.c   |    2 +-
 include/linux/proc_fs.h |    2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.20-rc6-mm3/include/linux/proc_fs.h.old	2007-02-06 08:34:02.000000000 +0100
+++ linux-2.6.20-rc6-mm3/include/linux/proc_fs.h	2007-02-06 08:34:09.000000000 +0100
@@ -128,8 +128,6 @@
 extern int proc_fill_super(struct super_block *,void *,int);
 extern struct inode *proc_get_inode(struct super_block *, unsigned int, struct proc_dir_entry *);
 
-extern int proc_match(int, const char *,struct proc_dir_entry *);
-
 /*
  * These are generic /proc routines that use the internal
  * "struct proc_dir_entry" tree to traverse the filesystem.
--- linux-2.6.20-rc6-mm3/fs/proc/generic.c.old	2007-02-06 08:34:17.000000000 +0100
+++ linux-2.6.20-rc6-mm3/fs/proc/generic.c	2007-02-06 08:34:25.000000000 +0100
@@ -33,7 +33,7 @@
 
 DEFINE_SPINLOCK(proc_subdir_lock);
 
-int proc_match(int len, const char *name, struct proc_dir_entry *de)
+static int proc_match(int len, const char *name, struct proc_dir_entry *de)
 {
 	if (de->namelen != len)
 		return 0;
--- linux-2.6.20-rc6-mm3/fs/proc/proc_sysctl.c.old	2007-02-06 08:34:33.000000000 +0100
+++ linux-2.6.20-rc6-mm3/fs/proc/proc_sysctl.c	2007-02-06 08:34:42.000000000 +0100
@@ -466,7 +466,7 @@
 	.d_revalidate	= proc_sys_revalidate,
 };
 
-struct proc_dir_entry *proc_sys_root;
+static struct proc_dir_entry *proc_sys_root;
 
 int proc_sys_init(void)
 {

