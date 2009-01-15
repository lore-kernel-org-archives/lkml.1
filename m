Return-Path: <linux-kernel-owner+w=401wt.eu-S935259AbZAOWT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935259AbZAOWT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760430AbZAOWCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:35 -0500
Received: from kroah.org ([198.145.64.141]:38417 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755865AbZAOWCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:22 -0500
Date: Thu, 15 Jan 2009 13:59:59 -0800
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
Subject: [patch 32/85] [PATCH 12/44] [CVE-2009-0029] System call wrappers
	part 02
Message-ID: <20090115215959.GG17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0012--CVE-2009-0029-System-call-wrappers-part-02.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit dbf040d9d1cbf1ef6250bdb095c5c118950bcde8 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sys.c   |   10 +++++-----
 kernel/timer.c |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -733,7 +733,7 @@ asmlinkage long sys_setresuid(uid_t ruid
 	return security_task_post_setuid(old_ruid, old_euid, old_suid, LSM_SETID_RES);
 }
 
-asmlinkage long sys_getresuid(uid_t __user *ruid, uid_t __user *euid, uid_t __user *suid)
+SYSCALL_DEFINE3(getresuid, uid_t __user *, ruid, uid_t __user *, euid, uid_t __user *, suid)
 {
 	int retval;
 
@@ -784,7 +784,7 @@ asmlinkage long sys_setresgid(gid_t rgid
 	return 0;
 }
 
-asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __user *sgid)
+SYSCALL_DEFINE3(getresgid, gid_t __user *, rgid, gid_t __user *, egid, gid_t __user *, sgid)
 {
 	int retval;
 
@@ -974,7 +974,7 @@ out:
 	return err;
 }
 
-asmlinkage long sys_getpgid(pid_t pid)
+SYSCALL_DEFINE1(getpgid, pid_t, pid)
 {
 	struct task_struct *p;
 	struct pid *grp;
@@ -1004,14 +1004,14 @@ out:
 
 #ifdef __ARCH_WANT_SYS_GETPGRP
 
-asmlinkage long sys_getpgrp(void)
+SYSCALL_DEFINE0(getpgrp)
 {
 	return sys_getpgid(0);
 }
 
 #endif
 
-asmlinkage long sys_getsid(pid_t pid)
+SYSCALL_DEFINE1(getsid, pid_t, pid)
 {
 	struct task_struct *p;
 	struct pid *sid;
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1108,7 +1108,7 @@ SYSCALL_DEFINE0(getpid)
  * value of ->real_parent under rcu_read_lock(), see
  * release_task()->call_rcu(delayed_put_task_struct).
  */
-asmlinkage long sys_getppid(void)
+SYSCALL_DEFINE0(getppid)
 {
 	int pid;
 
@@ -1119,25 +1119,25 @@ asmlinkage long sys_getppid(void)
 	return pid;
 }
 
-asmlinkage long sys_getuid(void)
+SYSCALL_DEFINE0(getuid)
 {
 	/* Only we change this so SMP safe */
 	return current->uid;
 }
 
-asmlinkage long sys_geteuid(void)
+SYSCALL_DEFINE0(geteuid)
 {
 	/* Only we change this so SMP safe */
 	return current->euid;
 }
 
-asmlinkage long sys_getgid(void)
+SYSCALL_DEFINE0(getgid)
 {
 	/* Only we change this so SMP safe */
 	return current->gid;
 }
 
-asmlinkage long sys_getegid(void)
+SYSCALL_DEFINE0(getegid)
 {
 	/* Only we change this so SMP safe */
 	return  current->egid;

