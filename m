Return-Path: <linux-kernel-owner+w=401wt.eu-S935597AbZAOWe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935597AbZAOWe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933944AbZAOWDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:34 -0500
Received: from kroah.org ([198.145.64.141]:38818 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933922AbZAOWDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:31 -0500
Date: Thu, 15 Jan 2009 14:01:05 -0800
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
Subject: [patch 57/85] [PATCH 37/44] [CVE-2009-0029] System call wrappers
	part 27
Message-ID: <20090115220105.GF17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0037--CVE-2009-0029-System-call-wrappers-part-27.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 1e7bfb2134dfec37ce04fb3a4ca89299e892d10c upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/exec.c              |    2 +-
 fs/filesystems.c       |    2 +-
 fs/nfsctl.c            |    4 ++--
 kernel/printk.c        |    2 +-
 kernel/ptrace.c        |    2 +-
 kernel/sysctl.c        |    4 ++--
 kernel/timer.c         |    2 +-
 security/keys/keyctl.c |   18 +++++++++---------
 8 files changed, 18 insertions(+), 18 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -105,7 +105,7 @@ static inline void put_binfmt(struct lin
  *
  * Also note that we take the address to load from from the file itself.
  */
-asmlinkage long sys_uselib(const char __user * library)
+SYSCALL_DEFINE1(uselib, const char __user *, library)
 {
 	struct file *file;
 	struct nameidata nd;
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -177,7 +177,7 @@ static int fs_maxindex(void)
 /*
  * Whee.. Weird sysv syscall. 
  */
-asmlinkage long sys_sysfs(int option, unsigned long arg1, unsigned long arg2)
+SYSCALL_DEFINE3(sysfs, int, option, unsigned long, arg1, unsigned long, arg2)
 {
 	int retval = -EINVAL;
 
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -82,8 +82,8 @@ static struct {
 	},
 };
 
-long
-asmlinkage sys_nfsservctl(int cmd, struct nfsctl_arg __user *arg, void __user *res)
+SYSCALL_DEFINE3(nfsservctl, int, cmd, struct nfsctl_arg __user *, arg,
+		void __user *, res)
 {
 	struct file *file;
 	void __user *p = &arg->u;
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -421,7 +421,7 @@ out:
 	return error;
 }
 
-asmlinkage long sys_syslog(int type, char __user *buf, int len)
+SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
 {
 	return do_syslog(type, buf, len);
 }
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -545,7 +545,7 @@ struct task_struct *ptrace_get_task_stru
 #define arch_ptrace_attach(child)	do { } while (0)
 #endif
 
-asmlinkage long sys_ptrace(long request, long pid, long addr, long data)
+SYSCALL_DEFINE4(ptrace, long, request, long, pid, long, addr, long, data)
 {
 	struct task_struct *child;
 	long ret;
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1614,7 +1614,7 @@ int do_sysctl(int __user *name, int nlen
 	return error;
 }
 
-asmlinkage long sys_sysctl(struct __sysctl_args __user *args)
+SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
 {
 	struct __sysctl_args tmp;
 	int error;
@@ -2925,7 +2925,7 @@ int sysctl_ms_jiffies(struct ctl_table *
 #else /* CONFIG_SYSCTL_SYSCALL */
 
 
-asmlinkage long sys_sysctl(struct __sysctl_args __user *args)
+SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
 {
 	struct __sysctl_args tmp;
 	int error;
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1345,7 +1345,7 @@ out:
 	return 0;
 }
 
-asmlinkage long sys_sysinfo(struct sysinfo __user *info)
+SYSCALL_DEFINE1(sysinfo, struct sysinfo __user *, info)
 {
 	struct sysinfo val;
 
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -54,11 +54,11 @@ static int key_get_type_from_user(char *
  * - returns the new key's serial number
  * - implements add_key()
  */
-asmlinkage long sys_add_key(const char __user *_type,
-			    const char __user *_description,
-			    const void __user *_payload,
-			    size_t plen,
-			    key_serial_t ringid)
+SYSCALL_DEFINE5(add_key, const char __user *, _type,
+		const char __user *, _description,
+		const void __user *, _payload,
+		size_t, plen,
+		key_serial_t, ringid)
 {
 	key_ref_t keyring_ref, key_ref;
 	char type[32], *description;
@@ -146,10 +146,10 @@ asmlinkage long sys_add_key(const char _
  *   - if the _callout_info string is empty, it will be rendered as "-"
  * - implements request_key()
  */
-asmlinkage long sys_request_key(const char __user *_type,
-				const char __user *_description,
-				const char __user *_callout_info,
-				key_serial_t destringid)
+SYSCALL_DEFINE4(request_key, const char __user *, _type,
+		const char __user *, _description,
+		const char __user *, _callout_info,
+		key_serial_t, destringid)
 {
 	struct key_type *ktype;
 	struct key *key;

