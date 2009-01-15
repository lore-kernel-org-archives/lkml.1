Return-Path: <linux-kernel-owner+w=401wt.eu-S935664AbZAOWgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935664AbZAOWgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933969AbZAOWDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:38 -0500
Received: from kroah.org ([198.145.64.141]:38860 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933922AbZAOWDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:35 -0500
Date: Thu, 15 Jan 2009 14:01:11 -0800
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
Subject: [patch 60/85] [PATCH 40/44] [CVE-2009-0029] System call wrappers
	part 30
Message-ID: <20090115220111.GI17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0040--CVE-2009-0029-System-call-wrappers-part-30.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 6559eed8ca7db0531a207cd80be5e28cd6f213c5 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/open.c     |   13 ++++++-------
 fs/stat.c     |   12 ++++++------
 fs/utimes.c   |    6 ++++--
 kernel/fork.c |    2 +-
 4 files changed, 17 insertions(+), 16 deletions(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -442,7 +442,7 @@ SYSCALL_ALIAS(sys_fallocate, SyS_falloca
  * We do this by temporarily clearing all FS-related capabilities and
  * switching the fsuid/fsgid around to the real ones.
  */
-asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
+SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 {
 	struct path path;
 	struct inode *inode;
@@ -633,8 +633,7 @@ out:
 	return err;
 }
 
-asmlinkage long sys_fchmodat(int dfd, const char __user *filename,
-			     mode_t mode)
+SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, mode_t, mode)
 {
 	struct path path;
 	struct inode *inode;
@@ -712,8 +711,8 @@ out:
 	return error;
 }
 
-asmlinkage long sys_fchownat(int dfd, const char __user *filename, uid_t user,
-			     gid_t group, int flag)
+SYSCALL_DEFINE5(fchownat, int, dfd, const char __user *, filename, uid_t, user,
+		gid_t, group, int, flag)
 {
 	struct path path;
 	int error = -EINVAL;
@@ -1060,8 +1059,8 @@ SYSCALL_DEFINE3(open, const char __user 
 	return ret;
 }
 
-asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
-			   int mode)
+SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
+		int, mode)
 {
 	long ret;
 
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -260,8 +260,8 @@ SYSCALL_DEFINE2(newlstat, char __user *,
 }
 
 #if !defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_SYS_NEWFSTATAT)
-asmlinkage long sys_newfstatat(int dfd, char __user *filename,
-				struct stat __user *statbuf, int flag)
+SYSCALL_DEFINE4(newfstatat, int, dfd, char __user *, filename,
+		struct stat __user *, statbuf, int, flag)
 {
 	struct kstat stat;
 	int error = -EINVAL;
@@ -293,8 +293,8 @@ SYSCALL_DEFINE2(newfstat, unsigned int, 
 	return error;
 }
 
-asmlinkage long sys_readlinkat(int dfd, const char __user *pathname,
-				char __user *buf, int bufsiz)
+SYSCALL_DEFINE4(readlinkat, int, dfd, const char __user *, pathname,
+		char __user *, buf, int, bufsiz)
 {
 	struct path path;
 	int error;
@@ -400,8 +400,8 @@ SYSCALL_DEFINE2(fstat64, unsigned long, 
 	return error;
 }
 
-asmlinkage long sys_fstatat64(int dfd, char __user *filename,
-			       struct stat64 __user *statbuf, int flag)
+SYSCALL_DEFINE4(fstatat64, int, dfd, char __user *, filename,
+		struct stat64 __user *, statbuf, int, flag)
 {
 	struct kstat stat;
 	int error = -EINVAL;
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -170,7 +170,8 @@ out:
 	return error;
 }
 
-asmlinkage long sys_utimensat(int dfd, char __user *filename, struct timespec __user *utimes, int flags)
+SYSCALL_DEFINE4(utimensat, int, dfd, char __user *, filename,
+		struct timespec __user *, utimes, int, flags)
 {
 	struct timespec tstimes[2];
 
@@ -187,7 +188,8 @@ asmlinkage long sys_utimensat(int dfd, c
 	return do_utimes(dfd, filename, utimes ? tstimes : NULL, flags);
 }
 
-asmlinkage long sys_futimesat(int dfd, char __user *filename, struct timeval __user *utimes)
+SYSCALL_DEFINE3(futimesat, int, dfd, char __user *, filename,
+		struct timeval __user *, utimes)
 {
 	struct timeval times[2];
 	struct timespec tstimes[2];
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1561,7 +1561,7 @@ static int unshare_fd(unsigned long unsh
  * constructed. Here we are modifying the current, active,
  * task_struct.
  */
-asmlinkage long sys_unshare(unsigned long unshare_flags)
+SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 {
 	int err = 0;
 	struct fs_struct *fs, *new_fs = NULL;

