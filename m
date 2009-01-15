Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbZAOUjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbZAOUjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932169AbZAOUCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:21 -0500
Received: from kroah.org ([198.145.64.141]:49500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765999AbZAOUCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:16 -0500
Date: Thu, 15 Jan 2009 11:59:38 -0800
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
Subject: [patch 61/94] [PATCH 30/44] [CVE-2009-0029] System call wrappers
	part 20
Message-ID: <20090115195938.GI14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0030--CVE-2009-0029-System-call-wrappers-part-20.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 3cdad42884bbd95d5aa01297e8236ea1bad70053 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/dcache.c     |    2 +-
 fs/namei.c      |    4 ++--
 fs/open.c       |    4 ++--
 fs/quota.c      |    3 ++-
 fs/read_write.c |   13 +++++++------
 5 files changed, 14 insertions(+), 12 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2095,7 +2095,7 @@ Elong:
  *		return NULL;
  *	}
  */
-asmlinkage long sys_getcwd(char __user *buf, unsigned long size)
+SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 {
 	int error;
 	struct path pwd, root;
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2080,7 +2080,7 @@ out_err:
 	return error;
 }
 
-asmlinkage long sys_mkdir(const char __user *pathname, int mode)
+SYSCALL_DEFINE2(mkdir, const char __user *, pathname, int, mode)
 {
 	return sys_mkdirat(AT_FDCWD, pathname, mode);
 }
@@ -2190,7 +2190,7 @@ exit1:
 	return error;
 }
 
-asmlinkage long sys_rmdir(const char __user *pathname)
+SYSCALL_DEFINE1(rmdir, const char __user *, pathname)
 {
 	return do_rmdir(AT_FDCWD, pathname);
 }
--- a/fs/open.c
+++ b/fs/open.c
@@ -527,7 +527,7 @@ SYSCALL_DEFINE2(access, const char __use
 	return sys_faccessat(AT_FDCWD, filename, mode);
 }
 
-asmlinkage long sys_chdir(const char __user * filename)
+SYSCALL_DEFINE1(chdir, const char __user *, filename)
 {
 	struct path path;
 	int error;
@@ -548,7 +548,7 @@ out:
 	return error;
 }
 
-asmlinkage long sys_fchdir(unsigned int fd)
+SYSCALL_DEFINE1(fchdir, unsigned int, fd)
 {
 	struct file *file;
 	struct inode *inode;
--- a/fs/quota.c
+++ b/fs/quota.c
@@ -368,7 +368,8 @@ static inline struct super_block *quotac
  * calls. Maybe we need to add the process quotas etc. in the future,
  * but we probably should use rlimits for that.
  */
-asmlinkage long sys_quotactl(unsigned int cmd, const char __user *special, qid_t id, void __user *addr)
+SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
+		qid_t, id, void __user *, addr)
 {
 	uint cmds, type;
 	struct super_block *sb = NULL;
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -356,7 +356,7 @@ static inline void file_pos_write(struct
 	file->f_pos = pos;
 }
 
-asmlinkage long sys_read(unsigned int fd, char __user * buf, size_t count)
+SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
 {
 	struct file *file;
 	ssize_t ret = -EBADF;
@@ -373,7 +373,8 @@ asmlinkage long sys_read(unsigned int fd
 	return ret;
 }
 
-asmlinkage long sys_write(unsigned int fd, const char __user * buf, size_t count)
+SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf,
+		size_t, count)
 {
 	struct file *file;
 	ssize_t ret = -EBADF;
@@ -675,8 +676,8 @@ ssize_t vfs_writev(struct file *file, co
 
 EXPORT_SYMBOL(vfs_writev);
 
-asmlinkage long
-sys_readv(unsigned long fd, const struct iovec __user *vec, unsigned long vlen)
+SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen)
 {
 	struct file *file;
 	ssize_t ret = -EBADF;
@@ -696,8 +697,8 @@ sys_readv(unsigned long fd, const struct
 	return ret;
 }
 
-asmlinkage long
-sys_writev(unsigned long fd, const struct iovec __user *vec, unsigned long vlen)
+SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen)
 {
 	struct file *file;
 	ssize_t ret = -EBADF;

