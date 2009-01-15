Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbZAOWWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbZAOWWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933723AbZAOWCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:42 -0500
Received: from kroah.org ([198.145.64.141]:38471 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754744AbZAOWC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:26 -0500
Date: Thu, 15 Jan 2009 14:00:07 -0800
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
Subject: [patch 36/85] [PATCH 16/44] [CVE-2009-0029] System call wrappers
	part 06
Message-ID: <20090115220007.GK17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0016--CVE-2009-0029-System-call-wrappers-part-06.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 5add95d4f7cf08f6f62510f19576992912387501 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4942,7 +4942,7 @@ int can_nice(const struct task_struct *p
  * sys_setpriority is a more generic, but much slower function that
  * does similar things.
  */
-asmlinkage long sys_nice(int increment)
+SYSCALL_DEFINE1(nice, int, increment)
 {
 	long nice, retval;
 
@@ -5233,8 +5233,8 @@ do_sched_setscheduler(pid_t pid, int pol
  * @policy: new policy.
  * @param: structure containing the new RT priority.
  */
-asmlinkage long
-sys_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
+SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
+		struct sched_param __user *, param)
 {
 	/* negative values for policy are not valid */
 	if (policy < 0)
@@ -5248,7 +5248,7 @@ sys_sched_setscheduler(pid_t pid, int po
  * @pid: the pid in question.
  * @param: structure containing the new RT priority.
  */
-asmlinkage long sys_sched_setparam(pid_t pid, struct sched_param __user *param)
+SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 {
 	return do_sched_setscheduler(pid, -1, param);
 }
@@ -5257,7 +5257,7 @@ asmlinkage long sys_sched_setparam(pid_t
  * sys_sched_getscheduler - get the policy (scheduling class) of a thread
  * @pid: the pid in question.
  */
-asmlinkage long sys_sched_getscheduler(pid_t pid)
+SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
 {
 	struct task_struct *p;
 	int retval;
@@ -5282,7 +5282,7 @@ asmlinkage long sys_sched_getscheduler(p
  * @pid: the pid in question.
  * @param: structure containing the RT priority.
  */
-asmlinkage long sys_sched_getparam(pid_t pid, struct sched_param __user *param)
+SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 {
 	struct sched_param lp;
 	struct task_struct *p;
@@ -5390,8 +5390,8 @@ static int get_user_cpu_mask(unsigned lo
  * @len: length in bytes of the bitmask pointed to by user_mask_ptr
  * @user_mask_ptr: user-space pointer to the new cpu mask
  */
-asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
-				      unsigned long __user *user_mask_ptr)
+SYSCALL_DEFINE3(sched_setaffinity, pid_t, pid, unsigned int, len,
+		unsigned long __user *, user_mask_ptr)
 {
 	cpumask_t new_mask;
 	int retval;
@@ -5435,8 +5435,8 @@ out_unlock:
  * @len: length in bytes of the bitmask pointed to by user_mask_ptr
  * @user_mask_ptr: user-space pointer to hold the current cpu mask
  */
-asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
-				      unsigned long __user *user_mask_ptr)
+SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
+		unsigned long __user *, user_mask_ptr)
 {
 	int ret;
 	cpumask_t mask;
@@ -5460,7 +5460,7 @@ asmlinkage long sys_sched_getaffinity(pi
  * This function yields the current CPU to other tasks. If there are no
  * other threads running on this CPU then this function will return.
  */
-asmlinkage long sys_sched_yield(void)
+SYSCALL_DEFINE0(sched_yield)
 {
 	struct rq *rq = this_rq_lock();
 
@@ -5601,7 +5601,7 @@ long __sched io_schedule_timeout(long ti
  * this syscall returns the maximum rt_priority that can be used
  * by a given scheduling class.
  */
-asmlinkage long sys_sched_get_priority_max(int policy)
+SYSCALL_DEFINE1(sched_get_priority_max, int, policy)
 {
 	int ret = -EINVAL;
 
@@ -5626,7 +5626,7 @@ asmlinkage long sys_sched_get_priority_m
  * this syscall returns the minimum rt_priority that can be used
  * by a given scheduling class.
  */
-asmlinkage long sys_sched_get_priority_min(int policy)
+SYSCALL_DEFINE1(sched_get_priority_min, int, policy)
 {
 	int ret = -EINVAL;
 

