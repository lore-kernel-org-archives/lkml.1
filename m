Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYFYHHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYFYHHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 03:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYFYHHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 03:07:34 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:52331 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbYFYHHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 03:07:33 -0400
Date: Wed, 25 Jun 2008 04:07:30 -0300
From: Gustavo Fernando Padovan <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org
Subject: [PATCH] kernel/signal.c: change vars pid and tgid types to pid_t
Message-ID: <20080625070730.GA15572@quasar.las>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Change the type of pid and tgid variables from int to the POSIX type
pid_t.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>


--- a/kernel/signal.c	2008-06-09 23:45:49.000000000 -0300
+++ b/kernel/signal.c	2008-06-11 19:55:55.000000000 -0300
@@ -1120,7 +1120,7 @@
  * is probably wrong.  Should make it like BSD or SYSV.
  */
 
-static int kill_something_info(int sig, struct siginfo *info, int pid)
+static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
 {
 	int ret;
 
@@ -2228,7 +2228,7 @@
 }
 
 asmlinkage long
-sys_kill(int pid, int sig)
+sys_kill(pid_t pid, int sig)
 {
 	struct siginfo info;
 
@@ -2241,7 +2241,7 @@
 	return kill_something_info(sig, &info, pid);
 }
 
-static int do_tkill(int tgid, int pid, int sig)
+static int do_tkill(pid_t tgid, pid_t pid, int sig)
 {
 	int error;
 	struct siginfo info;
@@ -2284,7 +2284,7 @@
  *  exists but it's not belonging to the target process anymore. This
  *  method solves the problem of threads exiting and PIDs getting reused.
  */
-asmlinkage long sys_tgkill(int tgid, int pid, int sig)
+asmlinkage long sys_tgkill(pid_t tgid, pid_t pid, int sig)
 {
 	/* This is only valid for single tasks */
 	if (pid <= 0 || tgid <= 0)
@@ -2297,7 +2297,7 @@
  *  Send a signal to only one task, even if it's a CLONE_THREAD task.
  */
 asmlinkage long
-sys_tkill(int pid, int sig)
+sys_tkill(pid_t pid, int sig)
 {
 	/* This is only valid for single tasks */
 	if (pid <= 0)
@@ -2307,7 +2307,7 @@
 }
 
 asmlinkage long
-sys_rt_sigqueueinfo(int pid, int sig, siginfo_t __user *uinfo)
+sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo)
 {
 	siginfo_t info;
 
