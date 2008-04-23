Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYDWRxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYDWRxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYDWRwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:52:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbYDWRwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:52:53 -0400
From: eparis@redhat.com
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, serue@us.ibm.com, Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/4] capability: commoncap.c whitespace, syntax, and other cleanups
Date: Wed, 23 Apr 2008 13:52:34 -0400
Message-Id: <12089731551015-git-send-email-eparis@redhat.com>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <12089731553073-git-send-email-eparis@redhat.com>
References: <12089731541206-git-send-email-eparis@redhat.com>
 <12089731553297-git-send-email-eparis@redhat.com>
 <12089731553073-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

This patch changes commoncap.c to fix whitespace and syntax issues.  Things that
are fixed may include (does not not have to include)

whitespace at end of lines
spaces followed by tabs
spaces used instead of tabs
spacing around parenthesis
location of { around structs and else clauses
location of * in pointer declarations
removal of initialization of static data to keep it in the right section
useless {} in if statemetns
useless checking for NULL before kfree
fixing of the indentation depth of switch statements
no assignments in if statements
include spaces around , in function calls
and any number of other things I forgot to mention

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 security/commoncap.c |  112 +++++++++++++++++++++++--------------------------
 1 files changed, 53 insertions(+), 59 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 8529057..96511ec 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -51,7 +51,7 @@ EXPORT_SYMBOL(cap_netlink_recv);
  * returns 0 when a task has a capability, but the kernel's capable()
  * returns 1 for this case.
  */
-int cap_capable (struct task_struct *tsk, int cap)
+int cap_capable(struct task_struct *tsk, int cap)
 {
 	/* Derived from include/linux/sched.h:capable. */
 	if (cap_raised(tsk->cap_effective, cap))
@@ -66,7 +66,7 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
 	return 0;
 }
 
-int cap_ptrace (struct task_struct *parent, struct task_struct *child)
+int cap_ptrace(struct task_struct *parent, struct task_struct *child)
 {
 	/* Derived from arch/i386/kernel/ptrace.c:sys_ptrace. */
 	if (!cap_issubset(child->cap_permitted, parent->cap_permitted) &&
@@ -75,8 +75,8 @@ int cap_ptrace (struct task_struct *parent, struct task_struct *child)
 	return 0;
 }
 
-int cap_capget (struct task_struct *target, kernel_cap_t *effective,
-		kernel_cap_t *inheritable, kernel_cap_t *permitted)
+int cap_capget(struct task_struct *target, kernel_cap_t *effective,
+	       kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
 	/* Derived from kernel/capability.c:sys_capget. */
 	*effective = target->cap_effective;
@@ -113,12 +113,11 @@ static inline int cap_inh_is_capped(void) { return 1; }
 
 #endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
 
-int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
-		      kernel_cap_t *inheritable, kernel_cap_t *permitted)
+int cap_capset_check(struct task_struct *target, kernel_cap_t *effective,
+		     kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
-	if (cap_block_setpcap(target)) {
+	if (cap_block_setpcap(target))
 		return -EPERM;
-	}
 	if (cap_inh_is_capped()
 	    && !cap_issubset(*inheritable,
 			     cap_combine(target->cap_inheritable,
@@ -134,22 +133,21 @@ int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
 	}
 
 	/* verify restrictions on target's new Permitted set */
-	if (!cap_issubset (*permitted,
-			   cap_combine (target->cap_permitted,
-					current->cap_permitted))) {
+	if (!cap_issubset(*permitted,
+			  cap_combine(target->cap_permitted,
+				      current->cap_permitted))) {
 		return -EPERM;
 	}
 
 	/* verify the _new_Effective_ is a subset of the _new_Permitted_ */
-	if (!cap_issubset (*effective, *permitted)) {
+	if (!cap_issubset(*effective, *permitted))
 		return -EPERM;
-	}
 
 	return 0;
 }
 
-void cap_capset_set (struct task_struct *target, kernel_cap_t *effective,
-		     kernel_cap_t *inheritable, kernel_cap_t *permitted)
+void cap_capset_set(struct task_struct *target, kernel_cap_t *effective,
+		    kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
 	target->cap_effective = *effective;
 	target->cap_inheritable = *inheritable;
@@ -171,7 +169,7 @@ int cap_inode_need_killpriv(struct dentry *dentry)
 	int error;
 
 	if (!inode->i_op || !inode->i_op->getxattr)
-	       return 0;
+		return 0;
 
 	error = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
 	if (error <= 0)
@@ -184,7 +182,7 @@ int cap_inode_killpriv(struct dentry *dentry)
 	struct inode *inode = dentry->d_inode;
 
 	if (!inode->i_op || !inode->i_op->removexattr)
-	       return 0;
+		return 0;
 
 	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
 }
@@ -215,11 +213,10 @@ static inline int cap_from_disk(struct vfs_cap_data *caps,
 		return -EINVAL;
 	}
 
-	if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE) {
+	if (magic_etc & VFS_CAP_FLAGS_EFFECTIVE)
 		bprm->cap_effective = true;
-	} else {
+	else
 		bprm->cap_effective = false;
-	}
 
 	for (i = 0; i < tocopy; ++i) {
 		bprm->cap_permitted.cap[i] =
@@ -295,7 +292,7 @@ static inline int get_file_caps(struct linux_binprm *bprm)
 }
 #endif
 
-int cap_bprm_set_security (struct linux_binprm *bprm)
+int cap_bprm_set_security(struct linux_binprm *bprm)
 {
 	int ret;
 
@@ -312,10 +309,10 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 	 *  and permitted sets of the executable file.
 	 */
 
-	if (!issecure (SECURE_NOROOT)) {
+	if (!issecure(SECURE_NOROOT)) {
 		if (bprm->e_uid == 0 || current->uid == 0) {
-			cap_set_full (bprm->cap_inheritable);
-			cap_set_full (bprm->cap_permitted);
+			cap_set_full(bprm->cap_inheritable);
+			cap_set_full(bprm->cap_permitted);
 		}
 		if (bprm->e_uid == 0)
 			bprm->cap_effective = true;
@@ -324,7 +321,7 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
 	return ret;
 }
 
-void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
+void cap_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
 {
 	/* Derived from fs/exec.c:compute_creds. */
 	kernel_cap_t new_permitted, working;
@@ -336,7 +333,7 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 	new_permitted = cap_combine(new_permitted, working);
 
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
-	    !cap_issubset (new_permitted, current->cap_permitted)) {
+	    !cap_issubset(new_permitted, current->cap_permitted)) {
 		set_dumpable(current->mm, suid_dumpable);
 		current->pdeath_signal = 0;
 
@@ -345,8 +342,8 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 				bprm->e_uid = current->uid;
 				bprm->e_gid = current->gid;
 			}
-			if (!capable (CAP_SETPCAP)) {
-				new_permitted = cap_intersect (new_permitted,
+			if (!capable(CAP_SETPCAP)) {
+				new_permitted = cap_intersect(new_permitted,
 							current->cap_permitted);
 			}
 		}
@@ -371,7 +368,7 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 	current->keep_capabilities = 0;
 }
 
-int cap_bprm_secureexec (struct linux_binprm *bprm)
+int cap_bprm_secureexec(struct linux_binprm *bprm)
 {
 	if (current->uid != 0) {
 		if (bprm->cap_effective)
@@ -414,7 +411,7 @@ int cap_inode_removexattr(struct dentry *dentry, char *name)
 }
 
 /* moved from kernel/sys.c. */
-/* 
+/*
  * cap_emulate_setxuid() fixes the effective / permitted capabilities of
  * a process after a call to setuid, setreuid, or setresuid.
  *
@@ -428,10 +425,10 @@ int cap_inode_removexattr(struct dentry *dentry, char *name)
  *  3) When set*uiding _from_ euid != 0 _to_ euid == 0, the effective
  *  capabilities are set to the permitted capabilities.
  *
- *  fsuid is handled elsewhere. fsuid == 0 and {r,e,s}uid!= 0 should 
+ *  fsuid is handled elsewhere. fsuid == 0 and {r,e,s}uid!= 0 should
  *  never happen.
  *
- *  -astor 
+ *  -astor
  *
  * cevans - New behaviour, Oct '99
  * A process may, via prctl(), elect to keep its capabilities when it
@@ -443,34 +440,31 @@ int cap_inode_removexattr(struct dentry *dentry, char *name)
  * files..
  * Thanks to Olaf Kirch and Peter Benie for spotting this.
  */
-static inline void cap_emulate_setxuid (int old_ruid, int old_euid,
-					int old_suid)
+static inline void cap_emulate_setxuid(int old_ruid, int old_euid,
+				       int old_suid)
 {
 	if ((old_ruid == 0 || old_euid == 0 || old_suid == 0) &&
 	    (current->uid != 0 && current->euid != 0 && current->suid != 0) &&
 	    !current->keep_capabilities) {
-		cap_clear (current->cap_permitted);
-		cap_clear (current->cap_effective);
-	}
-	if (old_euid == 0 && current->euid != 0) {
-		cap_clear (current->cap_effective);
+		cap_clear(current->cap_permitted);
+		cap_clear(current->cap_effective);
 	}
-	if (old_euid != 0 && current->euid == 0) {
+	if (old_euid == 0 && current->euid != 0)
+		cap_clear(current->cap_effective);
+	if (old_euid != 0 && current->euid == 0)
 		current->cap_effective = current->cap_permitted;
-	}
 }
 
-int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
-			  int flags)
+int cap_task_post_setuid(uid_t old_ruid, uid_t old_euid, uid_t old_suid,
+			 int flags)
 {
 	switch (flags) {
 	case LSM_SETID_RE:
 	case LSM_SETID_ID:
 	case LSM_SETID_RES:
 		/* Copied from kernel/sys.c:setreuid/setuid/setresuid. */
-		if (!issecure (SECURE_NO_SETUID_FIXUP)) {
-			cap_emulate_setxuid (old_ruid, old_euid, old_suid);
-		}
+		if (!issecure(SECURE_NO_SETUID_FIXUP))
+			cap_emulate_setxuid(old_ruid, old_euid, old_suid);
 		break;
 	case LSM_SETID_FS:
 		{
@@ -480,10 +474,10 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
 
 			/*
 			 * FIXME - is fsuser used for all CAP_FS_MASK capabilities?
-			 *          if not, we might be a bit too harsh here.
+			 *	   if not, we might be a bit too harsh here.
 			 */
 
-			if (!issecure (SECURE_NO_SETUID_FIXUP)) {
+			if (!issecure(SECURE_NO_SETUID_FIXUP)) {
 				if (old_fsuid == 0 && current->fsuid != 0) {
 					current->cap_effective =
 						cap_drop_fs_set(
@@ -511,7 +505,7 @@ int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
  * task_setnice, assumes that
  *   . if capable(cap_sys_nice), then those actions should be allowed
  *   . if not capable(cap_sys_nice), but acting on your own processes,
- *   	then those actions should be allowed
+ *	then those actions should be allowed
  * This is insufficient now since you can call code without suid, but
  * yet with increased caps.
  * So we check for increased caps on the target process.
@@ -524,18 +518,18 @@ static inline int cap_safe_nice(struct task_struct *p)
 	return 0;
 }
 
-int cap_task_setscheduler (struct task_struct *p, int policy,
-			   struct sched_param *lp)
+int cap_task_setscheduler(struct task_struct *p, int policy,
+			  struct sched_param *lp)
 {
 	return cap_safe_nice(p);
 }
 
-int cap_task_setioprio (struct task_struct *p, int ioprio)
+int cap_task_setioprio(struct task_struct *p, int ioprio)
 {
 	return cap_safe_nice(p);
 }
 
-int cap_task_setnice (struct task_struct *p, int nice)
+int cap_task_setnice(struct task_struct *p, int nice)
 {
 	return cap_safe_nice(p);
 }
@@ -557,22 +551,22 @@ long cap_prctl_drop(unsigned long cap)
 	return 0;
 }
 #else
-int cap_task_setscheduler (struct task_struct *p, int policy,
-			   struct sched_param *lp)
+int cap_task_setscheduler(struct task_struct *p, int policy,
+			  struct sched_param *lp)
 {
 	return 0;
 }
-int cap_task_setioprio (struct task_struct *p, int ioprio)
+int cap_task_setioprio(struct task_struct *p, int ioprio)
 {
 	return 0;
 }
-int cap_task_setnice (struct task_struct *p, int nice)
+int cap_task_setnice(struct task_struct *p, int nice)
 {
 	return 0;
 }
 #endif
 
-void cap_task_reparent_to_init (struct task_struct *p)
+void cap_task_reparent_to_init(struct task_struct *p)
 {
 	cap_set_init_eff(p->cap_effective);
 	cap_clear(p->cap_inheritable);
@@ -581,7 +575,7 @@ void cap_task_reparent_to_init (struct task_struct *p)
 	return;
 }
 
-int cap_syslog (int type)
+int cap_syslog(int type)
 {
 	if ((type != 3 && type != 10) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
-- 
1.5.2.1

