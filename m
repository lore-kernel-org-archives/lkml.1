Return-Path: <linux-kernel-owner+w=401wt.eu-S933593AbZAOUe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbZAOUe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765931AbZAOUCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:09 -0500
Received: from kroah.org ([198.145.64.141]:49372 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932233AbZAOUCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:06 -0500
Date: Thu, 15 Jan 2009 11:59:19 -0800
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
Subject: [patch 52/94] [PATCH 21/44] [CVE-2009-0029] System call wrappers
	part 11
Message-ID: <20090115195919.GZ14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0021--CVE-2009-0029-System-call-wrappers-part-11.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 257ac264d69017270fbc3cf5536953525db4076c upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/open.c  |    2 +-
 fs/stat.c  |   20 ++++++++++++--------
 fs/super.c |    2 +-
 3 files changed, 14 insertions(+), 10 deletions(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -174,7 +174,7 @@ out:
 	return error;
 }
 
-asmlinkage long sys_fstatfs64(unsigned int fd, size_t sz, struct statfs64 __user *buf)
+SYSCALL_DEFINE3(fstatfs64, unsigned int, fd, size_t, sz, struct statfs64 __user *, buf)
 {
 	struct file * file;
 	struct statfs64 tmp;
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -162,7 +162,8 @@ SYSCALL_DEFINE2(stat, char __user *, fil
 
 	return error;
 }
-asmlinkage long sys_lstat(char __user * filename, struct __old_kernel_stat __user * statbuf)
+
+SYSCALL_DEFINE2(lstat, char __user *, filename, struct __old_kernel_stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_lstat_fd(AT_FDCWD, filename, &stat);
@@ -172,7 +173,8 @@ asmlinkage long sys_lstat(char __user * 
 
 	return error;
 }
-asmlinkage long sys_fstat(unsigned int fd, struct __old_kernel_stat __user * statbuf)
+
+SYSCALL_DEFINE2(fstat, unsigned int, fd, struct __old_kernel_stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_fstat(fd, &stat);
@@ -235,7 +237,7 @@ static int cp_new_stat(struct kstat *sta
 	return copy_to_user(statbuf,&tmp,sizeof(tmp)) ? -EFAULT : 0;
 }
 
-asmlinkage long sys_newstat(char __user *filename, struct stat __user *statbuf)
+SYSCALL_DEFINE2(newstat, char __user *, filename, struct stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_stat_fd(AT_FDCWD, filename, &stat);
@@ -246,7 +248,7 @@ asmlinkage long sys_newstat(char __user 
 	return error;
 }
 
-asmlinkage long sys_newlstat(char __user *filename, struct stat __user *statbuf)
+SYSCALL_DEFINE2(newlstat, char __user *, filename, struct stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_lstat_fd(AT_FDCWD, filename, &stat);
@@ -280,7 +282,7 @@ out:
 }
 #endif
 
-asmlinkage long sys_newfstat(unsigned int fd, struct stat __user *statbuf)
+SYSCALL_DEFINE2(newfstat, unsigned int, fd, struct stat __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_fstat(fd, &stat);
@@ -365,7 +367,7 @@ static long cp_new_stat64(struct kstat *
 	return copy_to_user(statbuf,&tmp,sizeof(tmp)) ? -EFAULT : 0;
 }
 
-asmlinkage long sys_stat64(char __user * filename, struct stat64 __user * statbuf)
+SYSCALL_DEFINE2(stat64, char __user *, filename, struct stat64 __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_stat(filename, &stat);
@@ -375,7 +377,8 @@ asmlinkage long sys_stat64(char __user *
 
 	return error;
 }
-asmlinkage long sys_lstat64(char __user * filename, struct stat64 __user * statbuf)
+
+SYSCALL_DEFINE2(lstat64, char __user *, filename, struct stat64 __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_lstat(filename, &stat);
@@ -385,7 +388,8 @@ asmlinkage long sys_lstat64(char __user 
 
 	return error;
 }
-asmlinkage long sys_fstat64(unsigned long fd, struct stat64 __user * statbuf)
+
+SYSCALL_DEFINE2(fstat64, unsigned long, fd, struct stat64 __user *, statbuf)
 {
 	struct kstat stat;
 	int error = vfs_fstat(fd, &stat);
--- a/fs/super.c
+++ b/fs/super.c
@@ -534,7 +534,7 @@ rescan:
 	return NULL;
 }
 
-asmlinkage long sys_ustat(unsigned dev, struct ustat __user * ubuf)
+SYSCALL_DEFINE2(ustat, unsigned, dev, struct ustat __user *, ubuf)
 {
         struct super_block *s;
         struct ustat tmp;

