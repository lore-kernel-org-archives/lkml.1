Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbZGBFcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbZGBFcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbZGBFb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:31:59 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:54689 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbZGBFbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:31:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ro5TzeGYpT3eqlUV3KP0lkwvgi9mH4Ri+qQmIvZpAjJLmucp7wik+LrEhFZFg6d+4z
         U3aLboUhb55MndxL9C5fStXi1FHTx/0FcZfcxaMAzsTQjgpLf+aTosf3a2FmNbTqMaFP
         qzJPXBKycLRlg3cKadntRVE0nK+ISqCyeJM6E=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: selinux@tycho.nsa.gov, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/8] SELinux hooks.c non-trivial-fixes.
Date: Wed,  1 Jul 2009 22:32:41 -0700
Message-Id: <1246512767-2999-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
References: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Fix some typo's.
Change some comments to look proper.
Fix some KERN_DEBUG messages to look proper.
---
 security/selinux/hooks.c |  265 ++++++++++++++++++++++-----------------------
 1 files changed, 130 insertions(+), 135 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 15c2a08..abd707a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -48,8 +48,8 @@
 #include <linux/netfilter_ipv6.h>
 #include <linux/tty.h>
 #include <net/icmp.h>
-#include <net/ip.h>		/* for local_port_range[] */
-#include <net/tcp.h>		/* struct or_callable used in sock_rcv_skb */
+#include <net/ip.h>		/* For local_port_range[]. */
+#include <net/tcp.h>		/* struct or_callable used in sock_rcv_skb. */
 #include <net/net_namespace.h>
 #include <net/netlabel.h>
 #include <linux/uaccess.h>
@@ -57,14 +57,14 @@
 #include <asm/atomic.h>
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
-#include <linux/netdevice.h>	/* for network interface checks */
+#include <linux/netdevice.h>	/* For network interface checks. */
 #include <linux/netlink.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/dccp.h>
 #include <linux/quota.h>
-#include <linux/un.h>		/* for Unix socket types */
-#include <net/af_unix.h>	/* for Unix socket types */
+#include <linux/un.h>		/* For Unix socket types. */
+#include <net/af_unix.h>	/* For Unix socket types. */
 #include <linux/parser.h>
 #include <linux/nfs_mount.h>
 #include <net/ipv6.h>
@@ -95,7 +95,7 @@ extern unsigned int policydb_loaded_version;
 extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
 extern struct security_operations *security_ops;
 
-/* SECMARK reference count */
+/* SECMARK reference count. */
 atomic_t selinux_secmark_refcount = ATOMIC_INIT(0);
 
 #ifdef CONFIG_SECURITY_SELINUX_DEVELOP
@@ -141,7 +141,7 @@ static DEFINE_SPINLOCK(sb_security_lock);
 static struct kmem_cache *sel_inode_cache;
 
 /**
- * selinux_secmark_enabled - Check to see if SECMARK is currently enabled
+ * selinux_secmark_enabled - Check to see if SECMARK is currently enabled.
  *
  * Description:
  * This function checks the SECMARK reference counter to see if any SECMARK
@@ -172,7 +172,7 @@ static void cred_init_security(void)
 }
 
 /*
- * get the security ID of a set of credentials
+ * Get the security ID of a set of credentials.
  */
 static inline u32 cred_sid(const struct cred *cred)
 {
@@ -183,7 +183,7 @@ static inline u32 cred_sid(const struct cred *cred)
 }
 
 /*
- * get the objective security ID of a task
+ * Get the objective security ID of a task.
  */
 static inline u32 task_sid(const struct task_struct *task)
 {
@@ -196,7 +196,7 @@ static inline u32 task_sid(const struct task_struct *task)
 }
 
 /*
- * get the subjective security ID of the current task
+ * Get the subjective security ID of the current task.
  */
 static inline u32 current_sid(void)
 {
@@ -206,7 +206,6 @@ static inline u32 current_sid(void)
 }
 
 /* Allocate and free functions for each kind of security blob. */
-
 static int inode_alloc_security(struct inode *inode)
 {
 	struct inode_security_struct *isec;
@@ -328,7 +327,7 @@ static void sk_free_security(struct sock *sk)
    any labeling or access decisions can be provided. */
 extern int ss_initialized;
 
-/* The file system's label must be initialized prior to use. */
+/* The filesystem's label must be initialized prior to use. */
 
 static char *labeling_behaviors[6] = {
 	"uses xattr",
@@ -414,7 +413,7 @@ static int sb_finish_set_opts(struct super_block *sb)
 		   assigned xattr values to the filesystem. */
 		if (!root_inode->i_op->getxattr) {
 			printk(KERN_WARNING "SELinux: (dev %s, type %s) has no "
-			       "xattr support\n", sb->s_id, sb->s_type->name);
+			       "xattr support.\n", sb->s_id, sb->s_type->name);
 			rc = -EOPNOTSUPP;
 			goto out;
 		}
@@ -422,7 +421,7 @@ static int sb_finish_set_opts(struct super_block *sb)
 		if (rc < 0 && rc != -ENODATA) {
 			if (rc == -EOPNOTSUPP)
 				printk(KERN_WARNING "SELinux: (dev %s, type "
-				       "%s) has no security xattr handler\n",
+				       "%s) Has no security xattr handler.\n",
 				       sb->s_id, sb->s_type->name);
 			else
 				printk(KERN_WARNING "SELinux: (dev %s, type "
@@ -435,10 +434,10 @@ static int sb_finish_set_opts(struct super_block *sb)
 	sbsec->flags |= (SE_SBINITIALIZED | SE_SBLABELSUPP);
 
 	if (sbsec->behavior > ARRAY_SIZE(labeling_behaviors))
-		printk(KERN_ERR "SELinux: initialized (dev %s, type %s), unknown behavior\n",
+		printk(KERN_ERR "SELinux: Initialized (dev %s, type %s), unknown behavior\n",
 		       sb->s_id, sb->s_type->name);
 	else
-		printk(KERN_DEBUG "SELinux: initialized (dev %s, type %s), %s\n",
+		printk(KERN_DEBUG "SELinux: Initialized (dev %s, type %s), %s\n",
 		       sb->s_id, sb->s_type->name,
 		       labeling_behaviors[sbsec->behavior-1]);
 
@@ -501,13 +500,13 @@ static int selinux_get_mnt_opts(const struct super_block *sb,
 		return -EINVAL;
 
 	tmp = sbsec->flags & SE_MNTMASK;
-	/* count the number of mount options for this sb */
+	/* Count the number of mount options for this sb. */
 	for (i = 0; i < 8; i++) {
 		if (tmp & 0x01)
 			opts->num_mnt_opts++;
 		tmp >>= 1;
 	}
-	/* Check if the Label support flag is set */
+	/* Check if the Label support flag is set. */
 	if (sbsec->flags & SE_SBLABELSUPP)
 		opts->num_mnt_opts++;
 
@@ -574,14 +573,14 @@ static int bad_option(struct superblock_security_struct *sbsec, char flag,
 {
 	char mnt_flags = sbsec->flags & SE_MNTMASK;
 
-	/* check if the old mount command had the same options */
+	/* Check if the old mount command had the same options. */
 	if (sbsec->flags & SE_SBINITIALIZED)
 		if (!(sbsec->flags & flag) ||
 		    (old_sid != new_sid))
 			return 1;
 
-	/* check if we were passed the same options twice,
-	 * aka someone passed context=a,context=b
+	/* Check if we were passed the same options twice,
+	 * aka someone passed context=a,context=b.
 	 */
 	if (!(sbsec->flags & SE_SBINITIALIZED))
 		if (mnt_flags & flag)
@@ -623,13 +622,13 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 		}
 		rc = -EINVAL;
 		printk(KERN_WARNING "SELinux: Unable to set superblock options "
-			"before the security server is initialized\n");
+			"before the security server is initialized.\n");
 		goto out;
 	}
 
 	/*
 	 * Binary mount data FS will come through this function twice.  Once
-	 * from an explicit call and once from the generic calls from the vfs.
+	 * from an explicit call and once from the generic calls from the VFS.
 	 * Since the generic VFS calls will not contain any security mount data
 	 * we need to skip the double mount verification.
 	 *
@@ -643,8 +642,8 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 		goto out;
 
 	/*
-	 * parse the mount options, check if they are valid sids.
-	 * also check if someone is trying to mount the same sb more
+	 * Parse the mount options, check if they are valid sids.
+	 * Also check if someone is trying to mount the same sb more
 	 * than once with different security options.
 	 */
 	for (i = 0; i < num_opts; i++) {
@@ -656,7 +655,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 					     strlen(mount_options[i]), &sid);
 		if (rc) {
 			printk(KERN_WARNING "SELinux: security_context_to_sid"
-			       "(%s) failed for (dev %s, type %s) errno=%d\n",
+			       "(%s) Failed for: (dev %s, type %s) errno=%d\n",
 			       mount_options[i], sb->s_id, name, rc);
 			goto out;
 		}
@@ -706,7 +705,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	}
 
 	if (sbsec->flags & SE_SBINITIALIZED) {
-		/* previously mounted with options, but not on this attempt? */
+		/* Previously mounted with options, but not on this attempt? */
 		if ((sbsec->flags & SE_MNTMASK) && !num_opts)
 			goto out_double_mount;
 		rc = 0;
@@ -724,7 +723,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 		goto out;
 	}
 
-	/* sets the context of the superblock for the fs being mounted. */
+	/* Sets the context of the superblock for the fs being mounted. */
 	if (fscontext_sid) {
 		rc = may_context_mount_sb_relabel(fscontext_sid, sbsec, cred);
 		if (rc)
@@ -735,7 +734,7 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 
 	/*
 	 * Switch to using mount point labeling behavior.
-	 * sets the label used on all file below the mountpoint, and will set
+	 * Sets the label used on all file below the mountpoint, and will set
 	 * the superblock context if not already set.
 	 */
 	if (context_sid) {
@@ -771,8 +770,8 @@ static int selinux_set_mnt_opts(struct super_block *sb,
 	if (defcontext_sid) {
 		if (sbsec->behavior != SECURITY_FS_USE_XATTR) {
 			rc = -EINVAL;
-			printk(KERN_WARNING "SELinux: defcontext option is "
-			       "invalid for this filesystem type\n");
+			printk(KERN_WARNING "SELinux: defcontext Option is "
+			       "invalid for this filesystem type.\n");
 			goto out;
 		}
 
@@ -792,7 +791,7 @@ out:
 	return rc;
 out_double_mount:
 	rc = -EINVAL;
-	printk(KERN_WARNING "SELinux: mount invalid.  Same superblock, different "
+	printk(KERN_WARNING "SELinux: Mount invalid.  Same superblock, different "
 	       "security settings for (dev %s, type %s)\n", sb->s_id, name);
 	goto out;
 }
@@ -808,7 +807,7 @@ static void selinux_sb_clone_mnt_opts(const struct super_block *oldsb,
 	int set_rootcontext =	(oldsbsec->flags & ROOTCONTEXT_MNT);
 
 	/*
-	 * if the parent was able to be mounted it clearly had no special lsm
+	 * If the parent was able to be mounted, and clearly had no special lsm
 	 * mount options.  thus we can safely put this sb on the list and deal
 	 * with it later
 	 */
@@ -820,10 +819,10 @@ static void selinux_sb_clone_mnt_opts(const struct super_block *oldsb,
 		return;
 	}
 
-	/* how can we clone if the old one wasn't set up?? */
+	/* How can we clone if the old one wasn't set up?? */
 	BUG_ON(!(oldsbsec->flags & SE_SBINITIALIZED));
 
-	/* if fs is reusing a sb, just let its options stand... */
+	/* If fs is reusing a sb, just let its options stand... */
 	if (newsbsec->flags & SE_SBINITIALIZED)
 		return;
 
@@ -936,7 +935,7 @@ static int selinux_parse_opts_str(char *options,
 			break;
 		default:
 			rc = -EINVAL;
-			printk(KERN_WARNING "SELinux:  unknown mount option\n");
+			printk(KERN_WARNING "SELinux:  Unknown mount option.\n");
 			goto out_err;
 
 		}
@@ -981,7 +980,7 @@ out_err:
 	return rc;
 }
 /*
- * string mount options parsing and call set the sbsec
+ * String mount options parsing and call set the sbsec.
  */
 static int superblock_doinit(struct super_block *sb, void *data)
 {
@@ -1042,7 +1041,7 @@ static void selinux_write_opts(struct seq_file *m,
 		default:
 			BUG();
 		};
-		/* we need a comma before each option */
+		/* We need a comma before each option. */
 		seq_putc(m, ',');
 		seq_puts(m, prefix);
 		if (has_comma)
@@ -1060,7 +1059,7 @@ static int selinux_sb_show_options(struct seq_file *m, struct super_block *sb)
 
 	rc = selinux_get_mnt_opts(sb, &opts);
 	if (rc) {
-		/* before policy load we may get EINVAL, don't show anything */
+		/* Before policy load we may get EINVAL, don't show anything. */
 		if (rc == -EINVAL)
 			rc = 0;
 		return rc;
@@ -1263,7 +1262,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 		}
 		if (!dentry) {
 			/*
-			 * this is can be hit on boot when a file is accessed
+			 * This is can be hit on boot when a file is accessed
 			 * before the policy is loaded.  When we load policy we
 			 * may find inodes that have no dentry on the
 			 * sbsec->isec_head list.  No reason to complain as these
@@ -1314,7 +1313,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 				kfree(context);
 				goto out_unlock;
 			}
-			/* Map ENODATA to the default file SID */
+			/* Map ENODATA to the default file SID. */
 			sid = sbsec->def_sid;
 			rc = 0;
 		} else {
@@ -1404,11 +1403,11 @@ static inline u32 signal_to_av(int sig)
 		perm = PROCESS__SIGCHLD;
 		break;
 	case SIGKILL:
-		/* Cannot be caught or ignored */
+		/* Cannot be caught or ignored. */
 		perm = PROCESS__SIGKILL;
 		break;
 	case SIGSTOP:
-		/* Cannot be caught or ignored */
+		/* Cannot be caught or ignored. */
 		perm = PROCESS__SIGSTOP;
 		break;
 	default:
@@ -1437,7 +1436,7 @@ static int cred_has_perm(const struct cred *actor,
  * Check permission between a pair of tasks, e.g. signal checks,
  * fork check, ptrace check, etc.
  * tsk1 is the actor and tsk2 is the target
- * - this uses the default subjective creds of tsk1
+ * - this uses the default subjective creds of tsk1.
  */
 static int task_has_perm(const struct task_struct *tsk1,
 			 const struct task_struct *tsk2,
@@ -1457,7 +1456,7 @@ static int task_has_perm(const struct task_struct *tsk1,
  * Check permission between current and another task, e.g. signal checks,
  * fork check, ptrace check, etc.
  * current is the actor and tsk2 is the target
- * - this uses current's subjective creds
+ * - this uses current's subjective creds.
  */
 static int current_has_perm(const struct task_struct *tsk,
 			    u32 perms)
@@ -1498,7 +1497,7 @@ static int task_has_capability(struct task_struct *tsk,
 		break;
 	default:
 		printk(KERN_ERR
-		       "SELinux:  out of range capability %d\n", cap);
+		       "SELinux:  Out of range capability. %d\n", cap);
 		BUG();
 	}
 
@@ -1657,7 +1656,7 @@ static int may_create_key(u32 ksid,
 #define MAY_UNLINK	1
 #define MAY_RMDIR	2
 
-/* Check whether a task can link, unlink, or rmdir a file/directory. */
+/* Check whether a task can link, unlink, or rmdir of a file/directory. */
 static int may_link(struct inode *dir,
 		    struct dentry *dentry,
 		    int kind)
@@ -1692,7 +1691,7 @@ static int may_link(struct inode *dir,
 		av = DIR__RMDIR;
 		break;
 	default:
-		printk(KERN_WARNING "SELinux: %s:  unrecognized kind %d\n",
+		printk(KERN_WARNING "SELinux: %s:  Unrecognized kind. %d\n",
 			__func__, kind);
 		return 0;
 	}
@@ -1853,7 +1852,6 @@ static inline u32 open_file_to_av(struct file *file)
 }
 
 /* Hook functions begin here. */
-
 static int selinux_ptrace_may_access(struct task_struct *child,
 				     unsigned int mode)
 {
@@ -1919,7 +1917,6 @@ static int selinux_capset(struct cred *new, const struct cred *old,
  * need to control this operation.  However, SELinux does control the use of
  * the CAP_SETUID and CAP_SETGID capabilities using the capable hook.
  */
-
 static int selinux_capable(struct task_struct *tsk, const struct cred *cred,
 			   int cap, int audit)
 {
@@ -2030,7 +2027,7 @@ static int selinux_quotactl(int cmds, int type, int id, struct super_block *sb)
 		rc = superblock_has_perm(cred, sb, FILESYSTEM__QUOTAGET, NULL);
 		break;
 	default:
-		rc = 0;  /* let the kernel handle invalid cmds */
+		rc = 0;  /* Let the kernel handle invalid cmds. */
 		break;
 	}
 	return rc;
@@ -2052,20 +2049,20 @@ static int selinux_syslog(int type)
 		return rc;
 
 	switch (type) {
-	case 3:		/* Read last kernel messages */
-	case 10:	/* Return size of the log buffer */
+	case 3:		/* Read last kernel messages. */
+	case 10:	/* Return size of the log buffer. */
 		rc = task_has_system(current, SYSTEM__SYSLOG_READ);
 		break;
-	case 6:		/* Disable logging to console */
-	case 7:		/* Enable logging to console */
-	case 8:		/* Set level of messages printed to console */
+	case 6:		/* Disable logging to console. */
+	case 7:		/* Enable logging to console. */
+	case 8:		/* Set level of messages printed to console. */
 		rc = task_has_system(current, SYSTEM__SYSLOG_CONSOLE);
 		break;
-	case 0:		/* Close log */
-	case 1:		/* Open log */
-	case 2:		/* Read from log */
-	case 4:		/* Read/clear last kernel messages */
-	case 5:		/* Clear ring buffer */
+	case 0:		/* Close log. */
+	case 1:		/* Open log. */
+	case 2:		/* Read from log. */
+	case 4:		/* Read/clear last kernel messages. */
+	case 5:		/* Clear ring buffer. */
 	default:
 		rc = task_has_system(current, SYSTEM__SYSLOG_MOD);
 		break;
@@ -2093,7 +2090,7 @@ static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
 	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
-/* binprm security operations */
+/* binprm security operations. */
 
 static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 {
@@ -2109,7 +2106,7 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 		return rc;
 
 	/* SELinux context only depends on initial program or script and not
-	 * the script interpreter */
+	 * the script interpreter. */
 	if (bprm->cred_prepared)
 		return 0;
 
@@ -2161,7 +2158,7 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 		if (rc)
 			return rc;
 
-		/* Check for shared state */
+		/* Check for shared state. */
 		if (bprm->unsafe & LSM_UNSAFE_SHARE) {
 			rc = avc_has_perm(old_tsec->sid, new_tsec->sid,
 					  SECCLASS_PROCESS, PROCESS__SHARE,
@@ -2171,7 +2168,7 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 		}
 
 		/* Make sure that anyone attempting to ptrace over a task that
-		 * changes its SID has the appropriate permit */
+		 * changes its SID has the appropriate permit. */
 		if (bprm->unsafe &
 		    (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)) {
 			struct task_struct *tracer;
@@ -2323,7 +2320,7 @@ static inline void flush_unauthorized_files(const struct cred *cred,
 }
 
 /*
- * Prepare a process for imminent new credential changes due to exec
+ * Prepare a process for imminent new credential changes due to exec.
  */
 static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 {
@@ -2345,7 +2342,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 	 * SID.  If not, reset all soft limits to the lower of the current
 	 * task's hard limit and the init task's soft limit.
 	 *
-	 * Note that the setting of hard limits (even to lower them) can be
+	 * Note: That the setting of hard limits (even to lower them) can be
 	 * controlled by the setrlimit check.  The inclusion of the init task's
 	 * soft limit into the computation is to avoid resetting soft limits
 	 * higher than the default soft limit for cases where the default is
@@ -2365,7 +2362,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 
 /*
  * Clean up the process immediately after the installation of new credentials
- * due to exec
+ * due to exec.
  */
 static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 {
@@ -2408,8 +2405,7 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 	read_unlock(&tasklist_lock);
 }
 
-/* superblock security operations */
-
+/* Superblock security operations. */
 static int selinux_sb_alloc_security(struct super_block *sb)
 {
 	return superblock_alloc_security(sb);
@@ -2521,7 +2517,7 @@ static int selinux_sb_kern_mount(struct super_block *sb, int flags, void *data)
 	if (rc)
 		return rc;
 
-	/* Allow all mounts performed by the kernel */
+	/* Allow all mounts performed by the kernel. */
 	if (flags & MS_KERNMOUNT)
 		return 0;
 
@@ -2564,8 +2560,7 @@ static int selinux_umount(struct vfsmount *mnt, int flags)
 				   FILESYSTEM__UNMOUNT, NULL);
 }
 
-/* inode security operations */
-
+/* Inode security operations. */
 static int selinux_inode_alloc_security(struct inode *inode)
 {
 	return inode_alloc_security(inode);
@@ -2600,7 +2595,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 					     &newsid);
 		if (rc) {
 			printk(KERN_WARNING "%s:  "
-			       "security_transition_sid failed, rc=%d (dev=%s "
+			       "security_transition_sid Failed, rc=%d (dev=%s "
 			       "ino=%ld)\n",
 			       __func__,
 			       -rc, inode->i_sb->s_id, inode->i_ino);
@@ -2819,8 +2814,8 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
 
 	rc = security_context_to_sid_force(value, size, &newsid);
 	if (rc) {
-		printk(KERN_ERR "SELinux:  unable to map context to SID"
-		       "for (%s, %lu), rc=%d\n",
+		printk(KERN_ERR "SELinux:  Unable to map context to SID"
+		       "for: (%s, %lu), rc=%d\n",
 		       inode->i_sb->s_id, inode->i_ino, -rc);
 		return;
 	}
@@ -2931,7 +2926,7 @@ static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
 	*secid = isec->sid;
 }
 
-/* file security operations */
+/* File security operations. */
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
 {
@@ -2943,7 +2938,7 @@ static int selinux_revalidate_file_permission(struct file *file, int mask)
 		return 0;
 	}
 
-	/* file_mask_to_av won't add FILE__WRITE if MAY_APPEND is set */
+	/* file_mask_to_av won't add FILE__WRITE if MAY_APPEND is set. */
 	if ((file->f_flags & O_APPEND) && (mask & MAY_WRITE))
 		mask |= MAY_APPEND;
 
@@ -3005,10 +3000,10 @@ static int file_map_prot_check(struct file *file, unsigned long prot, int shared
 #endif
 
 	if (file) {
-		/* read access is always possible with a mapping */
+		/* Read access is always possible with a mapping. */
 		u32 av = FILE__READ;
 
-		/* write access only matters if the mapping is shared */
+		/* Write access only matters if the mapping is shared. */
 		if (shared && (prot & PROT_WRITE))
 			av |= FILE__WRITE;
 
@@ -3103,13 +3098,13 @@ static int selinux_file_fcntl(struct file *file, unsigned int cmd,
 			err = file_has_perm(cred, file, FILE__WRITE);
 			break;
 		}
-		/* fall through */
+		/* Fall through. */
 	case F_SETOWN:
 	case F_SETSIG:
 	case F_GETFL:
 	case F_GETOWN:
 	case F_GETSIG:
-		/* Just check FD__USE permission */
+		/* Just check FD__USE permission. */
 		err = file_has_perm(cred, file, 0);
 		break;
 	case F_GETLK:
@@ -3149,13 +3144,13 @@ static int selinux_file_send_sigiotask(struct task_struct *tsk,
 	u32 perm;
 	struct file_security_struct *fsec;
 
-	/* struct fown_struct is never outside the context of a struct file */
+	/* Struct fown_struct is never outside the context of a struct file. */
 	file = container_of(fown, struct file, f_owner);
 
 	fsec = file->f_security;
 
 	if (!signum)
-		perm = signal_to_av(SIGIO); /* as per send_sigio_to_task */
+		perm = signal_to_av(SIGIO); /* As per send_sigio_to_task. */
 	else
 		perm = signal_to_av(signum);
 
@@ -3207,7 +3202,7 @@ static int selinux_task_create(unsigned long clone_flags)
 }
 
 /*
- * detach and free the LSM part of a set of credentials
+ * Detach and free the LSM part of a set of credentials.
  */
 static void selinux_cred_free(struct cred *cred)
 {
@@ -3217,7 +3212,7 @@ static void selinux_cred_free(struct cred *cred)
 }
 
 /*
- * prepare a new set of credentials for modification
+ * Prepare a new set of credentials for modification.
  */
 static int selinux_cred_prepare(struct cred *new, const struct cred *old,
 				gfp_t gfp)
@@ -3236,8 +3231,8 @@ static int selinux_cred_prepare(struct cred *new, const struct cred *old,
 }
 
 /*
- * set the security data for a kernel service
- * - all the creation contexts are set to unlabelled
+ * Set the security data for a kernel service
+ * - all the creation contexts are set to unlabelled.
  */
 static int selinux_kernel_act_as(struct cred *new, u32 secid)
 {
@@ -3259,8 +3254,8 @@ static int selinux_kernel_act_as(struct cred *new, u32 secid)
 }
 
 /*
- * set the file creation context in a security record to the same as the
- * objective context of the specified inode
+ * Set the file creation context in a security record to the same as the
+ * objective context of the specified inode.
  */
 static int selinux_kernel_create_files_as(struct cred *new, struct inode *inode)
 {
@@ -3368,7 +3363,7 @@ static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
 	int rc;
 
 	if (!sig)
-		perm = PROCESS__SIGNULL; /* null signal; existence test */
+		perm = PROCESS__SIGNULL; /* NULL signal; existence test. */
 	else
 		perm = signal_to_av(sig);
 	if (secid)
@@ -3394,7 +3389,7 @@ static void selinux_task_to_inode(struct task_struct *p,
 	isec->initialized = 1;
 }
 
-/* Returns error only if unable to parse addresses */
+/* Returns error only if unable to parse addresses. */
 static int selinux_parse_skb_ipv4(struct sk_buff *skb,
 			struct avc_audit_data *ad, u8 *proto)
 {
@@ -3475,7 +3470,7 @@ out:
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 
-/* Returns error only if unable to parse addresses */
+/* Returns error only if unable to parse addresses. */
 static int selinux_parse_skb_ipv6(struct sk_buff *skb,
 			struct avc_audit_data *ad, u8 *proto)
 {
@@ -3538,7 +3533,7 @@ static int selinux_parse_skb_ipv6(struct sk_buff *skb,
 		break;
 	}
 
-	/* includes fragments */
+	/* Includes fragments. */
 	default:
 		break;
 	}
@@ -3546,7 +3541,7 @@ out:
 	return ret;
 }
 
-#endif /* IPV6 */
+#endif /* IPV6. */
 
 static int selinux_parse_skb(struct sk_buff *skb, struct avc_audit_data *ad,
 			     char **_addrp, int src, u8 *proto)
@@ -3590,7 +3585,7 @@ okay:
 }
 
 /**
- * selinux_skb_peerlbl_sid - Determine the peer label of a packet
+ * selinux_skb_peerlbl_sid - Determine the peer label of a packet.
  * @skb: the packet
  * @family: protocol family
  * @sid: the packet's peer label SID
@@ -3617,15 +3612,15 @@ static int selinux_skb_peerlbl_sid(struct sk_buff *skb, u16 family, u32 *sid)
 	err = security_net_peersid_resolve(nlbl_sid, nlbl_type, xfrm_sid, sid);
 	if (unlikely(err)) {
 		printk(KERN_WARNING
-		       "SELinux: failure in selinux_skb_peerlbl_sid(),"
-		       " unable to determine packet's peer label\n");
+		       "SELinux: Failure in selinux_skb_peerlbl_sid(),"
+		       " unable to determine packet's peer label.\n");
 		return -EACCES;
 	}
 
 	return 0;
 }
 
-/* socket security operations */
+/* Socket security operations. */
 static int socket_has_perm(struct task_struct *task, struct socket *sock,
 			   u32 perms)
 {
@@ -3953,11 +3948,11 @@ static int selinux_socket_unix_stream_connect(struct socket *sock,
 	if (err)
 		return err;
 
-	/* connecting socket */
+	/* Connecting socket. */
 	ssec = sock->sk->sk_security;
 	ssec->peer_sid = other_isec->sid;
 
-	/* server child socket */
+	/* Server child socket. */
 	ssec = newsk->sk_security;
 	ssec->peer_sid = isec->sid;
 	err = security_sid_mls_copy(other_isec->sid, ssec->peer_sid, &ssec->sid);
@@ -4066,7 +4061,7 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	if (family != PF_INET && family != PF_INET6)
 		return 0;
 
-	/* Handle mapped IPv4 packets arriving via IPv6 sockets */
+	/* Handle mapped IPv4 packets arriving via IPv6 sockets. */
 	if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
 		family = PF_INET;
 
@@ -4240,7 +4235,7 @@ static int selinux_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	u32 newsid;
 	u32 peersid;
 
-	/* handle mapped IPv4 packets arriving via IPv6 sockets */
+	/* Handle mapped IPv4 packets arriving via IPv6 sockets. */
 	if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
 		family = PF_INET;
 
@@ -4274,7 +4269,7 @@ static void selinux_inet_csk_clone(struct sock *newsk,
 	   time it will have been created and available. */
 
 	/* We don't need to take any sort of lock here as we are the only
-	 * thread with access to newsksec */
+	 * thread with access to newsksec. */
 	selinux_netlbl_inet_csk_clone(newsk, req->rsk_ops->family);
 }
 
@@ -4283,7 +4278,7 @@ static void selinux_inet_conn_established(struct sock *sk, struct sk_buff *skb)
 	u16 family = sk->sk_family;
 	struct sk_security_struct *sksec = sk->sk_security;
 
-	/* handle mapped IPv4 packets arriving via IPv6 sockets */
+	/* Handle mapped IPv4 packets arriving via IPv6 sockets. */
 	if (family == PF_INET6 && skb->protocol == htons(ETH_P_IP))
 		family = PF_INET;
 
@@ -4314,14 +4309,14 @@ static int selinux_nlmsg_perm(struct sock *sk, struct sk_buff *skb)
 	if (err) {
 		if (err == -EINVAL) {
 			audit_log(current->audit_context, GFP_KERNEL, AUDIT_SELINUX_ERR,
-				  "SELinux:  unrecognized netlink message"
+				  "SELinux:  Unrecognized netlink message"
 				  " type=%hu for sclass=%hu\n",
 				  nlh->nlmsg_type, isec->sclass);
 			if (!selinux_enforcing || security_get_allow_unknown())
 				err = 0;
 		}
 
-		/* Ignore */
+		/* Ignore. */
 		if (err == -ENOENT)
 			err = 0;
 		goto out;
@@ -4378,10 +4373,10 @@ static unsigned int selinux_ip_forward(struct sk_buff *skb, int ifindex,
 			return NF_DROP;
 
 	if (netlbl_active)
-		/* we do this in the FORWARD path and not the POST_ROUTING
+		/* We do this in the FORWARD path and not the POST_ROUTING
 		 * path because we want to make sure we apply the necessary
 		 * labeling before IPsec is applied so we can leverage AH
-		 * protection */
+		 * protection. */
 		if (selinux_netlbl_skbuff_setsid(skb, family, peer_sid) != 0)
 			return NF_DROP;
 
@@ -4406,7 +4401,7 @@ static unsigned int selinux_ipv6_forward(unsigned int hooknum,
 {
 	return selinux_ip_forward(skb, in->ifindex, PF_INET6);
 }
-#endif	/* IPV6 */
+#endif	/* IPV6. */
 
 static unsigned int selinux_ip_output(struct sk_buff *skb,
 				      u16 family)
@@ -4416,9 +4411,9 @@ static unsigned int selinux_ip_output(struct sk_buff *skb,
 	if (!netlbl_enabled())
 		return NF_ACCEPT;
 
-	/* we do this in the LOCAL_OUT path and not the POST_ROUTING path
+	/* We do this in the LOCAL_OUT path and not the POST_ROUTING path
 	 * because we want to make sure we apply the necessary labeling
-	 * before IPsec is applied so we can leverage AH protection */
+	 * before IPsec is applied so we can leverage AH protection. */
 	if (skb->sk) {
 		struct sk_security_struct *sksec = skb->sk->sk_security;
 		sid = sksec->sid;
@@ -4493,7 +4488,7 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 	 * packet transformation so allow the packet to pass without any checks
 	 * since we'll have another chance to perform access control checks
 	 * when the packet is on it's final way out.
-	 * NOTE: there appear to be some IPv6 multicast cases where skb->dst
+	 * NOTE: There appear to be some IPv6 multicast cases where skb->dst
 	 *       is NULL, in this case go ahead and apply access control. */
 	if (skb_dst(skb) != NULL && skb_dst(skb)->xfrm != NULL)
 		return NF_ACCEPT;
@@ -4506,7 +4501,7 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 	/* if the packet is being forwarded then get the peer label from the
 	 * packet itself; otherwise check to see if it is from a local
 	 * application or the kernel, if from an application get the peer label
-	 * from the sending socket, otherwise use the kernel's sid */
+	 * from the sending socket, otherwise use the kernel's sid. */
 	sk = skb->sk;
 	if (sk == NULL) {
 		switch (family) {
@@ -4585,9 +4580,9 @@ static unsigned int selinux_ipv6_postroute(unsigned int hooknum,
 {
 	return selinux_ip_postroute(skb, out->ifindex, PF_INET6);
 }
-#endif	/* IPV6 */
+#endif	/* IPV6. */
 
-#endif	/* CONFIG_NETFILTER */
+#endif	/* CONFIG_NETFILTER. */
 
 static int selinux_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
@@ -4692,7 +4687,7 @@ static void selinux_msg_msg_free_security(struct msg_msg *msg)
 	msg_msg_free_security(msg);
 }
 
-/* message queue security operations */
+/* Message queue security operations. */
 static int selinux_msg_queue_alloc_security(struct msg_queue *msq)
 {
 	struct ipc_security_struct *isec;
@@ -4778,12 +4773,12 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 	msec = msg->security;
 
 	/*
-	 * First time through, need to assign label to the message
+	 * First time through, need to assign label to the message.
 	 */
 	if (msec->sid == SECINITSID_UNLABELED) {
 		/*
 		 * Compute new sid based on current process and
-		 * message queue this message will be stored in
+		 * message queue this message will be stored in.
 		 */
 		rc = security_transition_sid(sid, isec->sid, SECCLASS_MSG,
 					     &msec->sid);
@@ -4798,7 +4793,7 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 	rc = avc_has_perm(sid, isec->sid, SECCLASS_MSGQ,
 			  MSGQ__WRITE, &ad);
 	if (!rc)
-		/* Can this process send the message */
+		/* Can this process send the message? */
 		rc = avc_has_perm(sid, msec->sid, SECCLASS_MSG,
 				  MSG__SEND, &ad);
 	if (!rc)
@@ -4833,7 +4828,7 @@ static int selinux_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 	return rc;
 }
 
-/* Shared Memory security operations */
+/* Shared Memory security operations. */
 static int selinux_shm_alloc_security(struct shmid_kernel *shp)
 {
 	struct ipc_security_struct *isec;
@@ -4879,7 +4874,7 @@ static int selinux_shm_associate(struct shmid_kernel *shp, int shmflg)
 			    SHM__ASSOCIATE, &ad);
 }
 
-/* Note, at this point, shp is locked down */
+/* Note: At this point, shp is locked down. */
 static int selinux_shm_shmctl(struct shmid_kernel *shp, int cmd)
 {
 	int perms;
@@ -4925,7 +4920,7 @@ static int selinux_shm_shmat(struct shmid_kernel *shp,
 	return ipc_has_perm(&shp->shm_perm, perms);
 }
 
-/* Semaphore security operations */
+/* Semaphore security operations. */
 static int selinux_sem_alloc_security(struct sem_array *sma)
 {
 	struct ipc_security_struct *isec;
@@ -5180,7 +5175,7 @@ static int selinux_setprocattr(struct task_struct *p,
 		if (sid == 0)
 			goto abort_change;
 
-		/* Only allow single threaded processes to change context */
+		/* Only allow single threaded processes to change context. */
 		error = -EPERM;
 		if (!is_single_threaded(p)) {
 			error = security_bounded_transition(tsec->sid, sid);
@@ -5277,7 +5272,7 @@ static int selinux_key_permission(key_ref_t key_ref,
 	struct key_security_struct *ksec;
 	u32 sid;
 
-	/* if no specific permissions are requested, we skip the
+	/* If no specific permissions are requested, we skip the
 	   permission check. No serious, additional covert channels
 	   appear to be created. */
 	if (perm == 0)
@@ -5517,14 +5512,14 @@ static __init int selinux_init(void)
 
 	secondary_ops = security_ops;
 	if (!secondary_ops)
-		panic("SELinux: No initial security operations\n");
+		panic("SELinux: No initial security operations.\n");
 	if (register_security(&selinux_ops))
 		panic("SELinux: Unable to register with kernel.\n");
 
 	if (selinux_enforcing)
-		printk(KERN_DEBUG "SELinux:  Starting in enforcing mode\n");
+		printk(KERN_DEBUG "SELinux:  Starting in enforcing mode.\n");
 	else
-		printk(KERN_DEBUG "SELinux:  Starting in permissive mode\n");
+		printk(KERN_DEBUG "SELinux:  Starting in permissive mode.\n");
 
 	return 0;
 }
@@ -5609,7 +5604,7 @@ static struct nf_hook_ops selinux_ipv6_ops[] = {
 	}
 };
 
-#endif	/* IPV6 */
+#endif	/* IPV6. */
 
 static int __init selinux_nf_ip_init(void)
 {
@@ -5618,7 +5613,7 @@ static int __init selinux_nf_ip_init(void)
 	if (!selinux_enabled)
 		goto out;
 
-	printk(KERN_DEBUG "SELinux:  Registering netfilter hooks\n");
+	printk(KERN_DEBUG "SELinux:  Registering netfilter hooks.\n");
 
 	err = nf_register_hooks(selinux_ipv4_ops, ARRAY_SIZE(selinux_ipv4_ops));
 	if (err)
@@ -5628,7 +5623,7 @@ static int __init selinux_nf_ip_init(void)
 	err = nf_register_hooks(selinux_ipv6_ops, ARRAY_SIZE(selinux_ipv6_ops));
 	if (err)
 		panic("SELinux: nf_register_hooks for IPv6: error %d\n", err);
-#endif	/* IPV6 */
+#endif	/* IPV6. */
 
 out:
 	return err;
@@ -5639,22 +5634,22 @@ __initcall(selinux_nf_ip_init);
 #ifdef CONFIG_SECURITY_SELINUX_DISABLE
 static void selinux_nf_ip_exit(void)
 {
-	printk(KERN_DEBUG "SELinux:  Unregistering netfilter hooks\n");
+	printk(KERN_DEBUG "SELinux:  Unregistering netfilter hooks.\n");
 
 	nf_unregister_hooks(selinux_ipv4_ops, ARRAY_SIZE(selinux_ipv4_ops));
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	nf_unregister_hooks(selinux_ipv6_ops, ARRAY_SIZE(selinux_ipv6_ops));
-#endif	/* IPV6 */
+#endif	/* IPV6. */
 }
 #endif
 
-#else /* CONFIG_NETFILTER */
+#else /* CONFIG_NETFILTER. */
 
 #ifdef CONFIG_SECURITY_SELINUX_DISABLE
 #define selinux_nf_ip_exit()
 #endif
 
-#endif /* CONFIG_NETFILTER */
+#endif /* CONFIG_NETFILTER. */
 
 #ifdef CONFIG_SECURITY_SELINUX_DISABLE
 static int selinux_disabled;
-- 
1.6.3.2

