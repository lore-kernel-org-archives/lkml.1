Return-Path: <linux-kernel-owner+w=401wt.eu-S936105AbZAOWb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936105AbZAOWb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933543AbZAOWD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:29 -0500
Received: from kroah.org ([198.145.64.141]:38763 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765303AbZAOWD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:27 -0500
Date: Thu, 15 Jan 2009 14:00:56 -0800
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
Subject: [patch 53/85] [PATCH 33/44] [CVE-2009-0029] System call wrappers
	part 23
Message-ID: <20090115220056.GB17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0033--CVE-2009-0029-System-call-wrappers-part-23.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 5a8a82b1d306a325d899b67715618413657efda4 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/eventpoll.c |   18 +++++++++---------
 fs/select.c    |    8 ++++----
 kernel/sys.c   |    6 +++---
 3 files changed, 16 insertions(+), 16 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1106,7 +1106,7 @@ retry:
 /*
  * Open an eventpoll file descriptor.
  */
-asmlinkage long sys_epoll_create1(int flags)
+SYSCALL_DEFINE1(epoll_create1, int, flags)
 {
 	int error, fd = -1;
 	struct eventpoll *ep;
@@ -1146,7 +1146,7 @@ error_return:
 	return fd;
 }
 
-asmlinkage long sys_epoll_create(int size)
+SYSCALL_DEFINE1(epoll_create, int, size)
 {
 	if (size < 0)
 		return -EINVAL;
@@ -1159,8 +1159,8 @@ asmlinkage long sys_epoll_create(int siz
  * the eventpoll file that enables the insertion/removal/change of
  * file descriptors inside the interest set.
  */
-asmlinkage long sys_epoll_ctl(int epfd, int op, int fd,
-			      struct epoll_event __user *event)
+SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
+		struct epoll_event __user *, event)
 {
 	int error;
 	struct file *file, *tfile;
@@ -1257,8 +1257,8 @@ error_return:
  * Implement the event wait interface for the eventpoll file. It is the kernel
  * part of the user space epoll_wait(2).
  */
-asmlinkage long sys_epoll_wait(int epfd, struct epoll_event __user *events,
-			       int maxevents, int timeout)
+SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
+		int, maxevents, int, timeout)
 {
 	int error;
 	struct file *file;
@@ -1315,9 +1315,9 @@ error_return:
  * Implement the event wait interface for the eventpoll file. It is the kernel
  * part of the user space epoll_pwait(2).
  */
-asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
-		int maxevents, int timeout, const sigset_t __user *sigmask,
-		size_t sigsetsize)
+SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
+		int, maxevents, int, timeout, const sigset_t __user *, sigmask,
+		size_t, sigsetsize)
 {
 	int error;
 	sigset_t ksigmask, sigsaved;
--- a/fs/select.c
+++ b/fs/select.c
@@ -374,8 +374,8 @@ out_nofds:
 	return ret;
 }
 
-asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
-			fd_set __user *exp, struct timeval __user *tvp)
+SYSCALL_DEFINE5(select, int, n, fd_set __user *, inp, fd_set __user *, outp,
+		fd_set __user *, exp, struct timeval __user *, tvp)
 {
 	s64 timeout = -1;
 	struct timeval tv;
@@ -727,8 +727,8 @@ static long do_restart_poll(struct resta
 	return ret;
 }
 
-asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
-			long timeout_msecs)
+SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
+		long, timeout_msecs)
 {
 	s64 timeout_jiffies;
 	int ret;
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1340,7 +1340,7 @@ asmlinkage long sys_newuname(struct new_
 	return errno;
 }
 
-asmlinkage long sys_sethostname(char __user *name, int len)
+SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 {
 	int errno;
 	char tmp[__NEW_UTS_LEN];
@@ -1362,7 +1362,7 @@ asmlinkage long sys_sethostname(char __u
 
 #ifdef __ARCH_WANT_SYS_GETHOSTNAME
 
-asmlinkage long sys_gethostname(char __user *name, int len)
+SYSCALL_DEFINE2(gethostname, char __user *, name, int, len)
 {
 	int i, errno;
 
@@ -1385,7 +1385,7 @@ asmlinkage long sys_gethostname(char __u
  * Only setdomainname; getdomainname can be implemented by calling
  * uname()
  */
-asmlinkage long sys_setdomainname(char __user *name, int len)
+SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
 {
 	int errno;
 	char tmp[__NEW_UTS_LEN];

