Return-Path: <linux-kernel-owner+w=401wt.eu-S933897AbZAOUlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbZAOUlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932256AbZAOUCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:25 -0500
Received: from kroah.org ([198.145.64.141]:49535 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932263AbZAOUCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:19 -0500
Date: Thu, 15 Jan 2009 11:59:44 -0800
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
Subject: [patch 64/94] [PATCH 33/44] [CVE-2009-0029] System call wrappers
	part 23
Message-ID: <20090115195944.GL14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0033--CVE-2009-0029-System-call-wrappers-part-23.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1110,7 +1110,7 @@ retry:
 /*
  * Open an eventpoll file descriptor.
  */
-asmlinkage long sys_epoll_create1(int flags)
+SYSCALL_DEFINE1(epoll_create1, int, flags)
 {
 	int error, fd = -1;
 	struct eventpoll *ep;
@@ -1150,7 +1150,7 @@ error_return:
 	return fd;
 }
 
-asmlinkage long sys_epoll_create(int size)
+SYSCALL_DEFINE1(epoll_create, int, size)
 {
 	if (size < 0)
 		return -EINVAL;
@@ -1163,8 +1163,8 @@ asmlinkage long sys_epoll_create(int siz
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
@@ -1261,8 +1261,8 @@ error_return:
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
@@ -1319,9 +1319,9 @@ error_return:
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
@@ -507,8 +507,8 @@ out_nofds:
 	return ret;
 }
 
-asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
-			fd_set __user *exp, struct timeval __user *tvp)
+SYSCALL_DEFINE5(select, int, n, fd_set __user *, inp, fd_set __user *, outp,
+		fd_set __user *, exp, struct timeval __user *, tvp)
 {
 	struct timespec end_time, *to = NULL;
 	struct timeval tv;
@@ -806,8 +806,8 @@ static long do_restart_poll(struct resta
 	return ret;
 }
 
-asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
-			long timeout_msecs)
+SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
+		long, timeout_msecs)
 {
 	struct timespec end_time, *to = NULL;
 	int ret;
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1328,7 +1328,7 @@ asmlinkage long sys_newuname(struct new_
 	return errno;
 }
 
-asmlinkage long sys_sethostname(char __user *name, int len)
+SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 {
 	int errno;
 	char tmp[__NEW_UTS_LEN];
@@ -1352,7 +1352,7 @@ asmlinkage long sys_sethostname(char __u
 
 #ifdef __ARCH_WANT_SYS_GETHOSTNAME
 
-asmlinkage long sys_gethostname(char __user *name, int len)
+SYSCALL_DEFINE2(gethostname, char __user *, name, int, len)
 {
 	int i, errno;
 	struct new_utsname *u;
@@ -1377,7 +1377,7 @@ asmlinkage long sys_gethostname(char __u
  * Only setdomainname; getdomainname can be implemented by calling
  * uname()
  */
-asmlinkage long sys_setdomainname(char __user *name, int len)
+SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
 {
 	int errno;
 	char tmp[__NEW_UTS_LEN];

