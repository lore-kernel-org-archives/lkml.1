Return-Path: <linux-kernel-owner+w=401wt.eu-S966580AbXEGU0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966580AbXEGU0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966576AbXEGU0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:26:05 -0400
Received: from [198.99.130.12] ([198.99.130.12]:60208 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966542AbXEGUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:25:35 -0400
Date: Mon, 7 May 2007 16:20:20 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 5/5] UML - Turn build warnings into comments
Message-ID: <20070507202020.GA8510@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

These haven't been fixed for ages.  Just make comments out of them.

arch/um/kernel/skas/process.c:181:2: warning: #warning Need to look up
+userspace_pid by cpu
arch/um/kernel/skas/process.c:187:2: warning: #warning Need to look up
+userspace_pid by cpu
arch/um/kernel/skas/process.c:194:2: warning: #warning need to loop over
+userspace_pids in kill_off_processes_skas

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/skas/process.c   |    9 ++++++---
 arch/um/os-Linux/skas/mem.c     |    2 +-
 arch/um/os-Linux/skas/process.c |    2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/skas/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/skas/process.c	2007-05-07 14:58:53.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/skas/process.c	2007-05-07 14:59:26.000000000 -0400
@@ -178,20 +178,23 @@ int start_uml_skas(void)
 
 int external_pid_skas(struct task_struct *task)
 {
-#warning Need to look up userspace_pid by cpu
+	/* FIXME: Need to look up userspace_pid by cpu */
 	return(userspace_pid[0]);
 }
 
 int thread_pid_skas(struct task_struct *task)
 {
-#warning Need to look up userspace_pid by cpu
+	/* FIXME: Need to look up userspace_pid by cpu */
 	return(userspace_pid[0]);
 }
 
 void kill_off_processes_skas(void)
 {
 	if(proc_mm)
-#warning need to loop over userspace_pids in kill_off_processes_skas
+		/*
+		 * FIXME: need to loop over userspace_pids in
+		 * kill_off_processes_skas
+		 */
 		os_kill_ptraced_process(userspace_pid[0], 1);
 	else {
 		struct task_struct *p;
Index: linux-2.6.21-mm/arch/um/os-Linux/skas/mem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/mem.c	2007-05-07 10:36:17.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/mem.c	2007-05-07 14:59:26.000000000 -0400
@@ -68,7 +68,7 @@ static inline long do_syscall_stub(struc
 	int err, pid = mm_idp->u.pid;
 
 	if(proc_mm)
-#warning Need to look up userspace_pid by cpu
+		/* FIXME: Need to look up userspace_pid by cpu */
 		pid = userspace_pid[0];
 
 	multi_count++;
Index: linux-2.6.21-mm/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/process.c	2007-05-07 14:59:00.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/process.c	2007-05-07 14:59:26.000000000 -0400
@@ -586,7 +586,7 @@ void switch_mm_skas(struct mm_id *mm_idp
 {
 	int err;
 
-#warning need cpu pid in switch_mm_skas
+	/* FIXME: need cpu pid in switch_mm_skas */
 	if(proc_mm){
 		err = ptrace(PTRACE_SWITCH_MM, userspace_pid[0], 0,
 			     mm_idp->u.mm_fd);
