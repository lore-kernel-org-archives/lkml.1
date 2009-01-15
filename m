Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbZAOUfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbZAOUfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765427AbZAOUCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:10 -0500
Received: from kroah.org ([198.145.64.141]:49388 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932235AbZAOUCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:07 -0500
Date: Thu, 15 Jan 2009 11:59:21 -0800
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
Subject: [patch 53/94] [PATCH 22/44] [CVE-2009-0029] System call wrappers
	part 12
Message-ID: <20090115195921.GA14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0022--CVE-2009-0029-System-call-wrappers-part-12.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 64fd1de3d821659ac0a3004fd5ee1de59e64af30 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xattr.c |   46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -251,9 +251,9 @@ setxattr(struct dentry *d, const char __
 	return error;
 }
 
-asmlinkage long
-sys_setxattr(const char __user *pathname, const char __user *name,
-	     const void __user *value, size_t size, int flags)
+SYSCALL_DEFINE5(setxattr, const char __user *, pathname,
+		const char __user *, name, const void __user *, value,
+		size_t, size, int, flags)
 {
 	struct path path;
 	int error;
@@ -270,9 +270,9 @@ sys_setxattr(const char __user *pathname
 	return error;
 }
 
-asmlinkage long
-sys_lsetxattr(const char __user *pathname, const char __user *name,
-	      const void __user *value, size_t size, int flags)
+SYSCALL_DEFINE5(lsetxattr, const char __user *, pathname,
+		const char __user *, name, const void __user *, value,
+		size_t, size, int, flags)
 {
 	struct path path;
 	int error;
@@ -289,9 +289,8 @@ sys_lsetxattr(const char __user *pathnam
 	return error;
 }
 
-asmlinkage long
-sys_fsetxattr(int fd, const char __user *name, const void __user *value,
-	      size_t size, int flags)
+SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
+		const void __user *,value, size_t, size, int, flags)
 {
 	struct file *f;
 	struct dentry *dentry;
@@ -349,9 +348,8 @@ getxattr(struct dentry *d, const char __
 	return error;
 }
 
-asmlinkage long
-sys_getxattr(const char __user *pathname, const char __user *name,
-	     void __user *value, size_t size)
+SYSCALL_DEFINE4(getxattr, const char __user *, pathname,
+		const char __user *, name, void __user *, value, size_t, size)
 {
 	struct path path;
 	ssize_t error;
@@ -364,9 +362,8 @@ sys_getxattr(const char __user *pathname
 	return error;
 }
 
-asmlinkage long
-sys_lgetxattr(const char __user *pathname, const char __user *name, void __user *value,
-	      size_t size)
+SYSCALL_DEFINE4(lgetxattr, const char __user *, pathname,
+		const char __user *, name, void __user *, value, size_t, size)
 {
 	struct path path;
 	ssize_t error;
@@ -379,8 +376,8 @@ sys_lgetxattr(const char __user *pathnam
 	return error;
 }
 
-asmlinkage long
-sys_fgetxattr(int fd, const char __user *name, void __user *value, size_t size)
+SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
+		void __user *, value, size_t, size)
 {
 	struct file *f;
 	ssize_t error = -EBADF;
@@ -424,8 +421,8 @@ listxattr(struct dentry *d, char __user 
 	return error;
 }
 
-asmlinkage long
-sys_listxattr(const char __user *pathname, char __user *list, size_t size)
+SYSCALL_DEFINE3(listxattr, const char __user *, pathname, char __user *, list,
+		size_t, size)
 {
 	struct path path;
 	ssize_t error;
@@ -438,8 +435,8 @@ sys_listxattr(const char __user *pathnam
 	return error;
 }
 
-asmlinkage long
-sys_llistxattr(const char __user *pathname, char __user *list, size_t size)
+SYSCALL_DEFINE3(llistxattr, const char __user *, pathname, char __user *, list,
+		size_t, size)
 {
 	struct path path;
 	ssize_t error;
@@ -452,8 +449,7 @@ sys_llistxattr(const char __user *pathna
 	return error;
 }
 
-asmlinkage long
-sys_flistxattr(int fd, char __user *list, size_t size)
+SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 {
 	struct file *f;
 	ssize_t error = -EBADF;
@@ -485,8 +481,8 @@ removexattr(struct dentry *d, const char
 	return vfs_removexattr(d, kname);
 }
 
-asmlinkage long
-sys_removexattr(const char __user *pathname, const char __user *name)
+SYSCALL_DEFINE2(removexattr, const char __user *, pathname,
+		const char __user *, name)
 {
 	struct path path;
 	int error;

