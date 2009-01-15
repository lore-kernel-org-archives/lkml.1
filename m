Return-Path: <linux-kernel-owner+w=401wt.eu-S934066AbZAOUoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066AbZAOUoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932284AbZAOUCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:35 -0500
Received: from kroah.org ([198.145.64.141]:49616 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932285AbZAOUC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:26 -0500
Date: Thu, 15 Jan 2009 11:59:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 70/94] [PATCH 39/44] [CVE-2009-0029] System call wrappers
	part 29
Message-ID: <20090115195957.GR14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0039--CVE-2009-0029-System-call-wrappers-part-29.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 2e4d0924eb0c403ce4014fa139d1d61bf2c44fee upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/inotify_user.c |    5 +++--
 fs/namei.c        |   21 ++++++++++-----------
 2 files changed, 13 insertions(+), 13 deletions(-)

--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -660,7 +660,8 @@ SYSCALL_DEFINE0(inotify_init)
 	return sys_inotify_init1(0);
 }
 
-asmlinkage long sys_inotify_add_watch(int fd, const char __user *pathname, u32 mask)
+SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
+		u32, mask)
 {
 	struct inode *inode;
 	struct inotify_device *dev;
@@ -704,7 +705,7 @@ fput_and_out:
 	return ret;
 }
 
-asmlinkage long sys_inotify_rm_watch(int fd, __s32 wd)
+SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 {
 	struct file *filp;
 	struct inotify_device *dev;
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1969,8 +1969,8 @@ static int may_mknod(mode_t mode)
 	}
 }
 
-asmlinkage long sys_mknodat(int dfd, const char __user *filename, int mode,
-				unsigned dev)
+SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, int, mode,
+		unsigned, dev)
 {
 	int error;
 	char *tmp;
@@ -2047,7 +2047,7 @@ int vfs_mkdir(struct inode *dir, struct 
 	return error;
 }
 
-asmlinkage long sys_mkdirat(int dfd, const char __user *pathname, int mode)
+SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, int, mode)
 {
 	int error = 0;
 	char * tmp;
@@ -2282,7 +2282,7 @@ slashes:
 	goto exit2;
 }
 
-asmlinkage long sys_unlinkat(int dfd, const char __user *pathname, int flag)
+SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
 {
 	if ((flag & ~AT_REMOVEDIR) != 0)
 		return -EINVAL;
@@ -2319,8 +2319,8 @@ int vfs_symlink(struct inode *dir, struc
 	return error;
 }
 
-asmlinkage long sys_symlinkat(const char __user *oldname,
-			      int newdfd, const char __user *newname)
+SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
+		int, newdfd, const char __user *, newname)
 {
 	int error;
 	char *from;
@@ -2409,9 +2409,8 @@ int vfs_link(struct dentry *old_dentry, 
  * with linux 2.0, and to avoid hard-linking to directories
  * and other special files.  --ADM
  */
-asmlinkage long sys_linkat(int olddfd, const char __user *oldname,
-			   int newdfd, const char __user *newname,
-			   int flags)
+SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
+		int, newdfd, const char __user *, newname, int, flags)
 {
 	struct dentry *new_dentry;
 	struct nameidata nd;
@@ -2607,8 +2606,8 @@ int vfs_rename(struct inode *old_dir, st
 	return error;
 }
 
-asmlinkage long sys_renameat(int olddfd, const char __user *oldname,
-			     int newdfd, const char __user *newname)
+SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
+		int, newdfd, const char __user *, newname)
 {
 	struct dentry *old_dir, *new_dir;
 	struct dentry *old_dentry, *new_dentry;

