Return-Path: <linux-kernel-owner+w=401wt.eu-S935672AbZAOW3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935672AbZAOW3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933266AbZAOWCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:53 -0500
Received: from kroah.org ([198.145.64.141]:38510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933687AbZAOWCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:40 -0500
Date: Thu, 15 Jan 2009 14:00:31 -0800
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
Subject: [patch 48/85] [PATCH 28/44] [CVE-2009-0029] System call wrappers
	part 18
Message-ID: <20090115220031.GW17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0028--CVE-2009-0029-System-call-wrappers-part-18.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit a6b42e83f249aad723589b2bdf6d1dfb2b0997c8 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/uid16.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -41,7 +41,7 @@ SYSCALL_DEFINE3(fchown16, unsigned int, 
 	return ret;
 }
 
-asmlinkage long sys_setregid16(old_gid_t rgid, old_gid_t egid)
+SYSCALL_DEFINE2(setregid16, old_gid_t, rgid, old_gid_t, egid)
 {
 	long ret = sys_setregid(low2highgid(rgid), low2highgid(egid));
 	/* avoid REGPARM breakage on x86: */
@@ -49,7 +49,7 @@ asmlinkage long sys_setregid16(old_gid_t
 	return ret;
 }
 
-asmlinkage long sys_setgid16(old_gid_t gid)
+SYSCALL_DEFINE1(setgid16, old_gid_t, gid)
 {
 	long ret = sys_setgid(low2highgid(gid));
 	/* avoid REGPARM breakage on x86: */
@@ -57,7 +57,7 @@ asmlinkage long sys_setgid16(old_gid_t g
 	return ret;
 }
 
-asmlinkage long sys_setreuid16(old_uid_t ruid, old_uid_t euid)
+SYSCALL_DEFINE2(setreuid16, old_uid_t, ruid, old_uid_t, euid)
 {
 	long ret = sys_setreuid(low2highuid(ruid), low2highuid(euid));
 	/* avoid REGPARM breakage on x86: */
@@ -65,7 +65,7 @@ asmlinkage long sys_setreuid16(old_uid_t
 	return ret;
 }
 
-asmlinkage long sys_setuid16(old_uid_t uid)
+SYSCALL_DEFINE1(setuid16, old_uid_t, uid)
 {
 	long ret = sys_setuid(low2highuid(uid));
 	/* avoid REGPARM breakage on x86: */
@@ -73,7 +73,7 @@ asmlinkage long sys_setuid16(old_uid_t u
 	return ret;
 }
 
-asmlinkage long sys_setresuid16(old_uid_t ruid, old_uid_t euid, old_uid_t suid)
+SYSCALL_DEFINE3(setresuid16, old_uid_t, ruid, old_uid_t, euid, old_uid_t, suid)
 {
 	long ret = sys_setresuid(low2highuid(ruid), low2highuid(euid),
 				 low2highuid(suid));
@@ -82,7 +82,7 @@ asmlinkage long sys_setresuid16(old_uid_
 	return ret;
 }
 
-asmlinkage long sys_getresuid16(old_uid_t __user *ruid, old_uid_t __user *euid, old_uid_t __user *suid)
+SYSCALL_DEFINE3(getresuid16, old_uid_t __user *, ruid, old_uid_t __user *, euid, old_uid_t __user *, suid)
 {
 	int retval;
 
@@ -93,7 +93,7 @@ asmlinkage long sys_getresuid16(old_uid_
 	return retval;
 }
 
-asmlinkage long sys_setresgid16(old_gid_t rgid, old_gid_t egid, old_gid_t sgid)
+SYSCALL_DEFINE3(setresgid16, old_gid_t, rgid, old_gid_t, egid, old_gid_t, sgid)
 {
 	long ret = sys_setresgid(low2highgid(rgid), low2highgid(egid),
 				 low2highgid(sgid));
@@ -102,7 +102,8 @@ asmlinkage long sys_setresgid16(old_gid_
 	return ret;
 }
 
-asmlinkage long sys_getresgid16(old_gid_t __user *rgid, old_gid_t __user *egid, old_gid_t __user *sgid)
+
+SYSCALL_DEFINE3(getresgid16, old_gid_t __user *, rgid, old_gid_t __user *, egid, old_gid_t __user *, sgid)
 {
 	int retval;
 
@@ -113,7 +114,7 @@ asmlinkage long sys_getresgid16(old_gid_
 	return retval;
 }
 
-asmlinkage long sys_setfsuid16(old_uid_t uid)
+SYSCALL_DEFINE1(setfsuid16, old_uid_t, uid)
 {
 	long ret = sys_setfsuid(low2highuid(uid));
 	/* avoid REGPARM breakage on x86: */
@@ -121,7 +122,7 @@ asmlinkage long sys_setfsuid16(old_uid_t
 	return ret;
 }
 
-asmlinkage long sys_setfsgid16(old_gid_t gid)
+SYSCALL_DEFINE1(setfsgid16, old_gid_t, gid)
 {
 	long ret = sys_setfsgid(low2highgid(gid));
 	/* avoid REGPARM breakage on x86: */

