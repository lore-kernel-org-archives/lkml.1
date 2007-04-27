Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbXD0QUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbXD0QUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbXD0QUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:20:18 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:57131 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbXD0QUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:20:17 -0400
To: jdike@addtoit.com
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
In-reply-to: <E1HhT90-0001dW-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Fri, 27 Apr 2007 18:18:02 +0200)
Subject: [patch] uml: remove #warnings
References: <E1HhT90-0001dW-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HhTAi-0001eK-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 27 Apr 2007 18:19:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

These haven't been fixed for ages.  Just make comments out of them.

arch/um/kernel/skas/process.c:181:2: warning: #warning Need to look up userspace_pid by cpu
arch/um/kernel/skas/process.c:187:2: warning: #warning Need to look up userspace_pid by cpu
arch/um/kernel/skas/process.c:194:2: warning: #warning need to loop over userspace_pids in kill_off_processes_skas

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/arch/um/kernel/skas/process.c
===================================================================
--- linux.orig/arch/um/kernel/skas/process.c	2007-04-26 15:12:23.000000000 +0200
+++ linux/arch/um/kernel/skas/process.c	2007-04-26 15:12:51.000000000 +0200
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
Index: linux/arch/um/os-Linux/skas/mem.c
===================================================================
--- linux.orig/arch/um/os-Linux/skas/mem.c	2007-04-26 14:20:23.000000000 +0200
+++ linux/arch/um/os-Linux/skas/mem.c	2007-04-26 15:12:51.000000000 +0200
@@ -55,7 +55,7 @@ static inline long do_syscall_stub(struc
 	int pid = mm_idp->u.pid;
 
 	if(proc_mm)
-#warning Need to look up userspace_pid by cpu
+		/* FIXME: Need to look up userspace_pid by cpu */
 		pid = userspace_pid[0];
 
 	multi_count++;
Index: linux/arch/um/os-Linux/skas/process.c
===================================================================
--- linux.orig/arch/um/os-Linux/skas/process.c	2007-04-26 14:20:23.000000000 +0200
+++ linux/arch/um/os-Linux/skas/process.c	2007-04-26 15:12:51.000000000 +0200
@@ -560,7 +560,7 @@ void switch_mm_skas(struct mm_id *mm_idp
 {
 	int err;
 
-#warning need cpu pid in switch_mm_skas
+	/* FIXME: need cpu pid in switch_mm_skas */
 	if(proc_mm){
 		err = ptrace(PTRACE_SWITCH_MM, userspace_pid[0], 0,
 			     mm_idp->u.mm_fd);
