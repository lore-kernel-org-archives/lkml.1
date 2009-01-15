Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbZAOUac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbZAOUac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765163AbZAOUBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:33 -0500
Received: from kroah.org ([198.145.64.141]:49215 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932096AbZAOUBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:01:08 -0500
Date: Thu, 15 Jan 2009 11:58:52 -0800
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
Subject: [patch 44/94] [PATCH 13/44] [CVE-2009-0029] System call wrappers
	part 03
Message-ID: <20090115195852.GR14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="0013--CVE-2009-0029-System-call-wrappers-part-03.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit ae1251ab785f6da87219df8352ffdac68bba23e4 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sys.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -470,7 +470,7 @@ void ctrl_alt_del(void)
  * SMP: There are not races, the GIDs are checked only by filesystem
  *      operations (as far as semantic preservation is concerned).
  */
-asmlinkage long sys_setregid(gid_t rgid, gid_t egid)
+SYSCALL_DEFINE2(setregid, gid_t, rgid, gid_t, egid)
 {
 	int old_rgid = current->gid;
 	int old_egid = current->egid;
@@ -519,7 +519,7 @@ asmlinkage long sys_setregid(gid_t rgid,
  *
  * SMP: Same implicit races as above.
  */
-asmlinkage long sys_setgid(gid_t gid)
+SYSCALL_DEFINE1(setgid, gid_t, gid)
 {
 	int old_egid = current->egid;
 	int retval;
@@ -589,7 +589,7 @@ static int set_user(uid_t new_ruid, int 
  * 100% compatible with BSD.  A program which uses just setuid() will be
  * 100% compatible with POSIX with saved IDs. 
  */
-asmlinkage long sys_setreuid(uid_t ruid, uid_t euid)
+SYSCALL_DEFINE2(setreuid, uid_t, ruid, uid_t, euid)
 {
 	int old_ruid, old_euid, old_suid, new_ruid, new_euid;
 	int retval;
@@ -651,7 +651,7 @@ asmlinkage long sys_setreuid(uid_t ruid,
  * will allow a root program to temporarily drop privileges and be able to
  * regain them by swapping the real and effective uid.  
  */
-asmlinkage long sys_setuid(uid_t uid)
+SYSCALL_DEFINE1(setuid, uid_t, uid)
 {
 	int old_euid = current->euid;
 	int old_ruid, old_suid, new_suid;
@@ -690,7 +690,7 @@ asmlinkage long sys_setuid(uid_t uid)
  * This function implements a generic ability to update ruid, euid,
  * and suid.  This allows you to implement the 4.4 compatible seteuid().
  */
-asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
+SYSCALL_DEFINE3(setresuid, uid_t, ruid, uid_t, euid, uid_t, suid)
 {
 	int old_ruid = current->uid;
 	int old_euid = current->euid;
@@ -747,7 +747,7 @@ SYSCALL_DEFINE3(getresuid, uid_t __user 
 /*
  * Same as above, but for rgid, egid, sgid.
  */
-asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
+SYSCALL_DEFINE3(setresgid, gid_t, rgid, gid_t, egid, gid_t, sgid)
 {
 	int retval;
 
@@ -802,7 +802,7 @@ SYSCALL_DEFINE3(getresgid, gid_t __user 
  * whatever uid it wants to). It normally shadows "euid", except when
  * explicitly set by setfsuid() or for access..
  */
-asmlinkage long sys_setfsuid(uid_t uid)
+SYSCALL_DEFINE1(setfsuid, uid_t, uid)
 {
 	int old_fsuid;
 
@@ -831,7 +831,7 @@ asmlinkage long sys_setfsuid(uid_t uid)
 /*
  * Samma på svenska..
  */
-asmlinkage long sys_setfsgid(gid_t gid)
+SYSCALL_DEFINE1(setfsgid, gid_t, gid)
 {
 	int old_fsgid;
 
@@ -1233,7 +1233,7 @@ int set_current_groups(struct group_info
 
 EXPORT_SYMBOL(set_current_groups);
 
-asmlinkage long sys_getgroups(int gidsetsize, gid_t __user *grouplist)
+SYSCALL_DEFINE2(getgroups, int, gidsetsize, gid_t __user *, grouplist)
 {
 	int i = 0;
 

