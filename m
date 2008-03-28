Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYC1OpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYC1OpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYC1Ogg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:36:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475AbYC1OfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:35:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/45] Add missing consts to xattr function arguments [ver #35]
To: torvalds@osdl.org, akpm@linux-foundation.org, trond.myklebust@fys.uio.no,
       chuck.lever@oracle.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 28 Mar 2008 14:31:48 +0000
Message-ID: <20080328143148.3483.50478.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
References: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing consts to xattr function arguments.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/xattr.c                          |   41 ++++++++++++++++---------------
 include/linux/security.h            |   46 ++++++++++++++++++++---------------
 include/linux/syscalls.h            |   30 ++++++++++++-----------
 include/linux/xattr.h               |    6 ++---
 security/commoncap.c                |    6 ++---
 security/dummy.c                    |   13 +++++-----
 security/security.c                 |   12 +++++----
 security/selinux/hooks.c            |   14 ++++++-----
 security/selinux/include/security.h |    2 +-
 security/selinux/ss/services.c      |    5 ++--
 security/smack/smack_lsm.c          |   12 +++++----
 11 files changed, 100 insertions(+), 87 deletions(-)


diff --git a/fs/xattr.c b/fs/xattr.c
index 3acab16..391c752 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -68,7 +68,7 @@ xattr_permission(struct inode *inode, const char *name, int mask)
 }
 
 int
-vfs_setxattr(struct dentry *dentry, char *name, void *value,
+vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags)
 {
 	struct inode *inode = dentry->d_inode;
@@ -132,7 +132,7 @@ out_noalloc:
 EXPORT_SYMBOL_GPL(xattr_getsecurity);
 
 ssize_t
-vfs_getxattr(struct dentry *dentry, char *name, void *value, size_t size)
+vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -188,7 +188,7 @@ vfs_listxattr(struct dentry *d, char *list, size_t size)
 EXPORT_SYMBOL_GPL(vfs_listxattr);
 
 int
-vfs_removexattr(struct dentry *dentry, char *name)
+vfs_removexattr(struct dentry *dentry, const char *name)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
@@ -219,7 +219,7 @@ EXPORT_SYMBOL_GPL(vfs_removexattr);
  * Extended attribute SET operations
  */
 static long
-setxattr(struct dentry *d, char __user *name, void __user *value,
+setxattr(struct dentry *d, const char __user *name, const void __user *value,
 	 size_t size, int flags)
 {
 	int error;
@@ -253,8 +253,8 @@ setxattr(struct dentry *d, char __user *name, void __user *value,
 }
 
 asmlinkage long
-sys_setxattr(char __user *path, char __user *name, void __user *value,
-	     size_t size, int flags)
+sys_setxattr(const char __user *path, const char __user *name,
+	     const void __user *value, size_t size, int flags)
 {
 	struct nameidata nd;
 	int error;
@@ -268,8 +268,8 @@ sys_setxattr(char __user *path, char __user *name, void __user *value,
 }
 
 asmlinkage long
-sys_lsetxattr(char __user *path, char __user *name, void __user *value,
-	      size_t size, int flags)
+sys_lsetxattr(const char __user *path, const char __user *name,
+	      const void __user *value, size_t size, int flags)
 {
 	struct nameidata nd;
 	int error;
@@ -283,7 +283,7 @@ sys_lsetxattr(char __user *path, char __user *name, void __user *value,
 }
 
 asmlinkage long
-sys_fsetxattr(int fd, char __user *name, void __user *value,
+sys_fsetxattr(int fd, const char __user *name, const void __user *value,
 	      size_t size, int flags)
 {
 	struct file *f;
@@ -304,7 +304,8 @@ sys_fsetxattr(int fd, char __user *name, void __user *value,
  * Extended attribute GET operations
  */
 static ssize_t
-getxattr(struct dentry *d, char __user *name, void __user *value, size_t size)
+getxattr(struct dentry *d, const char __user *name, void __user *value,
+	 size_t size)
 {
 	ssize_t error;
 	void *kvalue = NULL;
@@ -338,8 +339,8 @@ getxattr(struct dentry *d, char __user *name, void __user *value, size_t size)
 }
 
 asmlinkage ssize_t
-sys_getxattr(char __user *path, char __user *name, void __user *value,
-	     size_t size)
+sys_getxattr(const char __user *path, const char __user *name,
+	     void __user *value, size_t size)
 {
 	struct nameidata nd;
 	ssize_t error;
@@ -353,7 +354,7 @@ sys_getxattr(char __user *path, char __user *name, void __user *value,
 }
 
 asmlinkage ssize_t
-sys_lgetxattr(char __user *path, char __user *name, void __user *value,
+sys_lgetxattr(const char __user *path, const char __user *name, void __user *value,
 	      size_t size)
 {
 	struct nameidata nd;
@@ -368,7 +369,7 @@ sys_lgetxattr(char __user *path, char __user *name, void __user *value,
 }
 
 asmlinkage ssize_t
-sys_fgetxattr(int fd, char __user *name, void __user *value, size_t size)
+sys_fgetxattr(int fd, const char __user *name, void __user *value, size_t size)
 {
 	struct file *f;
 	ssize_t error = -EBADF;
@@ -413,7 +414,7 @@ listxattr(struct dentry *d, char __user *list, size_t size)
 }
 
 asmlinkage ssize_t
-sys_listxattr(char __user *path, char __user *list, size_t size)
+sys_listxattr(const char __user *path, char __user *list, size_t size)
 {
 	struct nameidata nd;
 	ssize_t error;
@@ -427,7 +428,7 @@ sys_listxattr(char __user *path, char __user *list, size_t size)
 }
 
 asmlinkage ssize_t
-sys_llistxattr(char __user *path, char __user *list, size_t size)
+sys_llistxattr(const char __user *path, char __user *list, size_t size)
 {
 	struct nameidata nd;
 	ssize_t error;
@@ -459,7 +460,7 @@ sys_flistxattr(int fd, char __user *list, size_t size)
  * Extended attribute REMOVE operations
  */
 static long
-removexattr(struct dentry *d, char __user *name)
+removexattr(struct dentry *d, const char __user *name)
 {
 	int error;
 	char kname[XATTR_NAME_MAX + 1];
@@ -474,7 +475,7 @@ removexattr(struct dentry *d, char __user *name)
 }
 
 asmlinkage long
-sys_removexattr(char __user *path, char __user *name)
+sys_removexattr(const char __user *path, const char __user *name)
 {
 	struct nameidata nd;
 	int error;
@@ -488,7 +489,7 @@ sys_removexattr(char __user *path, char __user *name)
 }
 
 asmlinkage long
-sys_lremovexattr(char __user *path, char __user *name)
+sys_lremovexattr(const char __user *path, const char __user *name)
 {
 	struct nameidata nd;
 	int error;
@@ -502,7 +503,7 @@ sys_lremovexattr(char __user *path, char __user *name)
 }
 
 asmlinkage long
-sys_fremovexattr(int fd, char __user *name)
+sys_fremovexattr(int fd, const char __user *name)
 {
 	struct file *f;
 	struct dentry *dentry;
diff --git a/include/linux/security.h b/include/linux/security.h
index f6edffd..f293a00 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -51,8 +51,9 @@ extern void cap_capset_set (struct task_struct *target, kernel_cap_t *effective,
 extern int cap_bprm_set_security (struct linux_binprm *bprm);
 extern void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe);
 extern int cap_bprm_secureexec(struct linux_binprm *bprm);
-extern int cap_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags);
-extern int cap_inode_removexattr(struct dentry *dentry, char *name);
+extern int cap_inode_setxattr(struct dentry *dentry, const char *name,
+			      const void *value, size_t size, int flags);
+extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
 extern int cap_inode_need_killpriv(struct dentry *dentry);
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
@@ -1335,13 +1336,13 @@ struct security_operations {
 	int (*inode_setattr)	(struct dentry *dentry, struct iattr *attr);
 	int (*inode_getattr) (struct vfsmount *mnt, struct dentry *dentry);
         void (*inode_delete) (struct inode *inode);
-	int (*inode_setxattr) (struct dentry *dentry, char *name, void *value,
-			       size_t size, int flags);
-	void (*inode_post_setxattr) (struct dentry *dentry, char *name, void *value,
-				     size_t size, int flags);
-	int (*inode_getxattr) (struct dentry *dentry, char *name);
+	int (*inode_setxattr) (struct dentry *dentry, const char *name,
+			       const void *value, size_t size, int flags);
+	void (*inode_post_setxattr) (struct dentry *dentry, const char *name,
+				     const void *value, size_t size, int flags);
+	int (*inode_getxattr) (struct dentry *dentry, const char *name);
 	int (*inode_listxattr) (struct dentry *dentry);
-	int (*inode_removexattr) (struct dentry *dentry, char *name);
+	int (*inode_removexattr) (struct dentry *dentry, const char *name);
 	int (*inode_need_killpriv) (struct dentry *dentry);
 	int (*inode_killpriv) (struct dentry *dentry);
 	int (*inode_getsecurity)(const struct inode *inode, const char *name, void **buffer, bool alloc);
@@ -1603,13 +1604,13 @@ int security_inode_permission(struct inode *inode, int mask, struct nameidata *n
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr);
 int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry);
 void security_inode_delete(struct inode *inode);
-int security_inode_setxattr(struct dentry *dentry, char *name,
-			     void *value, size_t size, int flags);
-void security_inode_post_setxattr(struct dentry *dentry, char *name,
-				   void *value, size_t size, int flags);
-int security_inode_getxattr(struct dentry *dentry, char *name);
+int security_inode_setxattr(struct dentry *dentry, const char *name,
+			    const void *value, size_t size, int flags);
+void security_inode_post_setxattr(struct dentry *dentry, const char *name,
+				  const void *value, size_t size, int flags);
+int security_inode_getxattr(struct dentry *dentry, const char *name);
 int security_inode_listxattr(struct dentry *dentry);
-int security_inode_removexattr(struct dentry *dentry, char *name);
+int security_inode_removexattr(struct dentry *dentry, const char *name);
 int security_inode_need_killpriv(struct dentry *dentry);
 int security_inode_killpriv(struct dentry *dentry);
 int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
@@ -2015,17 +2016,21 @@ static inline int security_inode_getattr (struct vfsmount *mnt,
 static inline void security_inode_delete (struct inode *inode)
 { }
 
-static inline int security_inode_setxattr (struct dentry *dentry, char *name,
-					   void *value, size_t size, int flags)
+static inline int security_inode_setxattr (struct dentry *dentry,
+					   const char *name, const void *value,
+					   size_t size, int flags)
 {
 	return cap_inode_setxattr(dentry, name, value, size, flags);
 }
 
-static inline void security_inode_post_setxattr (struct dentry *dentry, char *name,
-						 void *value, size_t size, int flags)
+static inline void security_inode_post_setxattr (struct dentry *dentry,
+						 const char *name,
+						 const void *value, size_t size,
+						 int flags)
 { }
 
-static inline int security_inode_getxattr (struct dentry *dentry, char *name)
+static inline int security_inode_getxattr (struct dentry *dentry,
+					   const char *name)
 {
 	return 0;
 }
@@ -2035,7 +2040,8 @@ static inline int security_inode_listxattr (struct dentry *dentry)
 	return 0;
 }
 
-static inline int security_inode_removexattr (struct dentry *dentry, char *name)
+static inline int security_inode_removexattr (struct dentry *dentry,
+					      const char *name)
 {
 	return cap_inode_removexattr(dentry, name);
 }
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4c2577b..f65e9fe 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -241,26 +241,28 @@ asmlinkage long sys_truncate64(const char __user *path, loff_t length);
 asmlinkage long sys_ftruncate64(unsigned int fd, loff_t length);
 #endif
 
-asmlinkage long sys_setxattr(char __user *path, char __user *name,
-				void __user *value, size_t size, int flags);
-asmlinkage long sys_lsetxattr(char __user *path, char __user *name,
-				void __user *value, size_t size, int flags);
-asmlinkage long sys_fsetxattr(int fd, char __user *name, void __user *value,
-				size_t size, int flags);
-asmlinkage ssize_t sys_getxattr(char __user *path, char __user *name,
+asmlinkage long sys_setxattr(const char __user *path, const char __user *name,
+			     const void __user *value, size_t size, int flags);
+asmlinkage long sys_lsetxattr(const char __user *path, const char __user *name,
+			      const void __user *value, size_t size, int flags);
+asmlinkage long sys_fsetxattr(int fd, const char __user *name,
+			      const void __user *value, size_t size, int flags);
+asmlinkage ssize_t sys_getxattr(const char __user *path, const char __user *name,
 				void __user *value, size_t size);
-asmlinkage ssize_t sys_lgetxattr(char __user *path, char __user *name,
+asmlinkage ssize_t sys_lgetxattr(const char __user *path, const char __user *name,
 				void __user *value, size_t size);
-asmlinkage ssize_t sys_fgetxattr(int fd, char __user *name,
+asmlinkage ssize_t sys_fgetxattr(int fd, const char __user *name,
 				void __user *value, size_t size);
-asmlinkage ssize_t sys_listxattr(char __user *path, char __user *list,
+asmlinkage ssize_t sys_listxattr(const char __user *path, char __user *list,
 				size_t size);
-asmlinkage ssize_t sys_llistxattr(char __user *path, char __user *list,
+asmlinkage ssize_t sys_llistxattr(const char __user *path, char __user *list,
 				size_t size);
 asmlinkage ssize_t sys_flistxattr(int fd, char __user *list, size_t size);
-asmlinkage long sys_removexattr(char __user *path, char __user *name);
-asmlinkage long sys_lremovexattr(char __user *path, char __user *name);
-asmlinkage long sys_fremovexattr(int fd, char __user *name);
+asmlinkage long sys_removexattr(const char __user *path,
+				const char __user *name);
+asmlinkage long sys_lremovexattr(const char __user *path,
+				 const char __user *name);
+asmlinkage long sys_fremovexattr(int fd, const char __user *name);
 
 asmlinkage unsigned long sys_brk(unsigned long brk);
 asmlinkage long sys_mprotect(unsigned long start, size_t len,
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index df6b95d..d131e35 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -47,10 +47,10 @@ struct xattr_handler {
 };
 
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
-ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
+ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
-int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
-int vfs_removexattr(struct dentry *, char *);
+int vfs_setxattr(struct dentry *, const char *, const void *, size_t, int);
+int vfs_removexattr(struct dentry *, const char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
diff --git a/security/commoncap.c b/security/commoncap.c
index e8c6940..534e411 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -395,8 +395,8 @@ int cap_bprm_secureexec (struct linux_binprm *bprm)
 		sec->egid != sec->gid);
 }
 
-int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
-		       size_t size, int flags)
+int cap_inode_setxattr(struct dentry *dentry, const char *name,
+		       const void *value, size_t size, int flags)
 {
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
 		if (!capable(CAP_SETFCAP))
@@ -409,7 +409,7 @@ int cap_inode_setxattr(struct dentry *dentry, char *name, void *value,
 	return 0;
 }
 
-int cap_inode_removexattr(struct dentry *dentry, char *name)
+int cap_inode_removexattr(struct dentry *dentry, const char *name)
 {
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
 		if (!capable(CAP_SETFCAP))
diff --git a/security/dummy.c b/security/dummy.c
index 3d3db47..3f0c8cb 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -370,8 +370,8 @@ static void dummy_inode_delete (struct inode *ino)
 	return;
 }
 
-static int dummy_inode_setxattr (struct dentry *dentry, char *name, void *value,
-				size_t size, int flags)
+static int dummy_inode_setxattr (struct dentry *dentry, const char *name,
+				 const void *value, size_t size, int flags)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
@@ -380,12 +380,13 @@ static int dummy_inode_setxattr (struct dentry *dentry, char *name, void *value,
 	return 0;
 }
 
-static void dummy_inode_post_setxattr (struct dentry *dentry, char *name, void *value,
-				       size_t size, int flags)
+static void dummy_inode_post_setxattr (struct dentry *dentry, const char *name,
+				       const void *value, size_t size,
+				       int flags)
 {
 }
 
-static int dummy_inode_getxattr (struct dentry *dentry, char *name)
+static int dummy_inode_getxattr (struct dentry *dentry, const char *name)
 {
 	return 0;
 }
@@ -395,7 +396,7 @@ static int dummy_inode_listxattr (struct dentry *dentry)
 	return 0;
 }
 
-static int dummy_inode_removexattr (struct dentry *dentry, char *name)
+static int dummy_inode_removexattr (struct dentry *dentry, const char *name)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
diff --git a/security/security.c b/security/security.c
index 881e372..87cd150 100644
--- a/security/security.c
+++ b/security/security.c
@@ -455,23 +455,23 @@ void security_inode_delete(struct inode *inode)
 	security_ops->inode_delete(inode);
 }
 
-int security_inode_setxattr(struct dentry *dentry, char *name,
-			     void *value, size_t size, int flags)
+int security_inode_setxattr(struct dentry *dentry, const char *name,
+			    const void *value, size_t size, int flags)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
 	return security_ops->inode_setxattr(dentry, name, value, size, flags);
 }
 
-void security_inode_post_setxattr(struct dentry *dentry, char *name,
-				   void *value, size_t size, int flags)
+void security_inode_post_setxattr(struct dentry *dentry, const char *name,
+				  const void *value, size_t size, int flags)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return;
 	security_ops->inode_post_setxattr(dentry, name, value, size, flags);
 }
 
-int security_inode_getxattr(struct dentry *dentry, char *name)
+int security_inode_getxattr(struct dentry *dentry, const char *name)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
@@ -485,7 +485,7 @@ int security_inode_listxattr(struct dentry *dentry)
 	return security_ops->inode_listxattr(dentry);
 }
 
-int security_inode_removexattr(struct dentry *dentry, char *name)
+int security_inode_removexattr(struct dentry *dentry, const char *name)
 {
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index cf79f25..1ac3e71 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2554,7 +2554,7 @@ static int selinux_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 	return dentry_has_perm(current, mnt, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_setotherxattr(struct dentry *dentry, char *name)
+static int selinux_inode_setotherxattr(struct dentry *dentry, const char *name)
 {
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof XATTR_SECURITY_PREFIX - 1)) {
@@ -2573,7 +2573,8 @@ static int selinux_inode_setotherxattr(struct dentry *dentry, char *name)
 	return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
 }
 
-static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
+static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
+				  const void *value, size_t size, int flags)
 {
 	struct task_security_struct *tsec = current->act_as->security;
 	struct inode *inode = dentry->d_inode;
@@ -2622,8 +2623,9 @@ static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value
 			    &ad);
 }
 
-static void selinux_inode_post_setxattr(struct dentry *dentry, char *name,
-                                        void *value, size_t size, int flags)
+static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
+                                        const void *value, size_t size,
+					int flags)
 {
 	struct inode *inode = dentry->d_inode;
 	struct inode_security_struct *isec = inode->i_security;
@@ -2646,7 +2648,7 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, char *name,
 	return;
 }
 
-static int selinux_inode_getxattr (struct dentry *dentry, char *name)
+static int selinux_inode_getxattr (struct dentry *dentry, const char *name)
 {
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
@@ -2656,7 +2658,7 @@ static int selinux_inode_listxattr (struct dentry *dentry)
 	return dentry_has_perm(current, NULL, dentry, FILE__GETATTR);
 }
 
-static int selinux_inode_removexattr (struct dentry *dentry, char *name)
+static int selinux_inode_removexattr (struct dentry *dentry, const char *name)
 {
 	if (strcmp(name, XATTR_NAME_SELINUX))
 		return selinux_inode_setotherxattr(dentry, name);
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index f7d2f03..526e959 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -83,7 +83,7 @@ int security_change_sid(u32 ssid, u32 tsid,
 int security_sid_to_context(u32 sid, char **scontext,
 	u32 *scontext_len);
 
-int security_context_to_sid(char *scontext, u32 scontext_len,
+int security_context_to_sid(const char *scontext, u32 scontext_len,
 	u32 *out_sid);
 
 int security_context_to_sid_default(char *scontext, u32 scontext_len, u32 *out_sid, u32 def_sid);
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index f374186..519b2c1 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -680,7 +680,8 @@ out:
 
 }
 
-static int security_context_to_sid_core(char *scontext, u32 scontext_len, u32 *sid, u32 def_sid)
+static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
+					u32 *sid, u32 def_sid)
 {
 	char *scontext2;
 	struct context context;
@@ -806,7 +807,7 @@ out:
  * Returns -%EINVAL if the context is invalid, -%ENOMEM if insufficient
  * memory is available, or 0 on success.
  */
-int security_context_to_sid(char *scontext, u32 scontext_len, u32 *sid)
+int security_context_to_sid(const char *scontext, u32 scontext_len, u32 *sid)
 {
 	return security_context_to_sid_core(scontext, scontext_len,
 	                                    sid, SECSID_NULL);
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 90f2534..a4ece02 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -575,8 +575,8 @@ static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_setxattr(struct dentry *dentry, char *name,
-				void *value, size_t size, int flags)
+static int smack_inode_setxattr(struct dentry *dentry, const char *name,
+				const void *value, size_t size, int flags)
 {
 	int rc = 0;
 
@@ -605,8 +605,8 @@ static int smack_inode_setxattr(struct dentry *dentry, char *name,
  * Set the pointer in the inode blob to the entry found
  * in the master label list.
  */
-static void smack_inode_post_setxattr(struct dentry *dentry, char *name,
-				      void *value, size_t size, int flags)
+static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
+				      const void *value, size_t size, int flags)
 {
 	struct inode_smack *isp;
 	char *nsp;
@@ -642,7 +642,7 @@ static void smack_inode_post_setxattr(struct dentry *dentry, char *name,
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_getxattr(struct dentry *dentry, char *name)
+static int smack_inode_getxattr(struct dentry *dentry, const char *name)
 {
 	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
 }
@@ -656,7 +656,7 @@ static int smack_inode_getxattr(struct dentry *dentry, char *name)
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_removexattr(struct dentry *dentry, char *name)
+static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 {
 	int rc = 0;
 

