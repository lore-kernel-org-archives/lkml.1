Return-Path: <linux-kernel-owner+w=401wt.eu-S934971AbZAOWTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934971AbZAOWTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763797AbZAOWCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:33 -0500
Received: from kroah.org ([198.145.64.141]:38398 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933687AbZAOWCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:21 -0500
Date: Thu, 15 Jan 2009 13:59:57 -0800
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
Subject: [patch 31/85] [PATCH 11/44] [CVE-2009-0029] System call wrappers
	part 01
Message-ID: <20090115215957.GF17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0011--CVE-2009-0029-System-call-wrappers-part-01.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 58fd3aa288939d3097fa04505b25c2f5e6e144d1 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/hrtimer.c |    4 ++--
 kernel/sys.c     |    2 +-
 kernel/time.c    |   14 +++++++-------
 kernel/timer.c   |    6 +++---
 4 files changed, 13 insertions(+), 13 deletions(-)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1560,8 +1560,8 @@ out:
 	return ret;
 }
 
-asmlinkage long
-sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
+SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
+		struct timespec __user *, rmtp)
 {
 	struct timespec tu;
 
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -853,7 +853,7 @@ asmlinkage long sys_setfsgid(gid_t gid)
 	return old_fsgid;
 }
 
-asmlinkage long sys_times(struct tms __user * tbuf)
+SYSCALL_DEFINE1(times, struct tms __user *, tbuf)
 {
 	/*
 	 *	In the SMP world we might just be unlucky and have one of
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -59,7 +59,7 @@ EXPORT_SYMBOL(sys_tz);
  * why not move it into the appropriate arch directory (for those
  * architectures that need it).
  */
-asmlinkage long sys_time(time_t __user * tloc)
+SYSCALL_DEFINE1(time, time_t __user *, tloc)
 {
 	time_t i = get_seconds();
 
@@ -77,7 +77,7 @@ asmlinkage long sys_time(time_t __user *
  * architectures that need it).
  */
 
-asmlinkage long sys_stime(time_t __user *tptr)
+SYSCALL_DEFINE1(stime, time_t __user *, tptr)
 {
 	struct timespec tv;
 	int err;
@@ -97,8 +97,8 @@ asmlinkage long sys_stime(time_t __user 
 
 #endif /* __ARCH_WANT_SYS_TIME */
 
-asmlinkage long sys_gettimeofday(struct timeval __user *tv,
-				 struct timezone __user *tz)
+SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
+		struct timezone __user *, tz)
 {
 	if (likely(tv != NULL)) {
 		struct timeval ktv;
@@ -182,8 +182,8 @@ int do_sys_settimeofday(struct timespec 
 	return 0;
 }
 
-asmlinkage long sys_settimeofday(struct timeval __user *tv,
-				struct timezone __user *tz)
+SYSCALL_DEFINE2(settimeofday, struct timeval __user *, tv,
+		struct timezone __user *, tz)
 {
 	struct timeval user_tv;
 	struct timespec	new_ts;
@@ -203,7 +203,7 @@ asmlinkage long sys_settimeofday(struct 
 	return do_sys_settimeofday(tv ? &new_ts : NULL, tz ? &new_tz : NULL);
 }
 
-asmlinkage long sys_adjtimex(struct timex __user *txc_p)
+SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
 {
 	struct timex txc;		/* Local copy of parameter */
 	int ret;
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1074,7 +1074,7 @@ void do_timer(unsigned long ticks)
  * For backwards compatibility?  This can be done in libc so Alpha
  * and all newer ports shouldn't need it.
  */
-asmlinkage long sys_alarm(unsigned int seconds)
+SYSCALL_DEFINE1(alarm, unsigned int, seconds)
 {
 	return alarm_setitimer(seconds);
 }
@@ -1097,7 +1097,7 @@ asmlinkage long sys_alarm(unsigned int s
  *
  * This is SMP safe as current->tgid does not change.
  */
-asmlinkage long sys_getpid(void)
+SYSCALL_DEFINE0(getpid)
 {
 	return task_tgid_vnr(current);
 }
@@ -1253,7 +1253,7 @@ signed long __sched schedule_timeout_uni
 EXPORT_SYMBOL(schedule_timeout_uninterruptible);
 
 /* Thread ID - the internal kernel "pid" */
-asmlinkage long sys_gettid(void)
+SYSCALL_DEFINE0(gettid)
 {
 	return task_pid_vnr(current);
 }

