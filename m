Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYEOBiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYEOBiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYEOBhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:37:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYEOBhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:37:06 -0400
Message-Id: <20080515013705.187425280@goodmis.org>
References: <20080515013028.056366414@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 14 May 2008 21:30:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       pq@iki.fi, proski@gnu.org, sandmann@redhat.com, a.p.zijlstra@chello.nl,
       linux-kbuild@vger.kernel.org, zippel@linux-m68k.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/4] ftrace: use the new kbuild CFLAGS_REMOVE for kernel directory
Content-Disposition: inline; filename=ftrace-cflags-remove-kernel.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the Makefile turd and uses the nice CFLAGS_REMOVE macro
in the kernel directory.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/Makefile |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux-sched-devel.git/kernel/Makefile
===================================================================
--- linux-sched-devel.git.orig/kernel/Makefile	2008-05-14 18:22:29.000000000 -0700
+++ linux-sched-devel.git/kernel/Makefile	2008-05-14 18:22:34.000000000 -0700
@@ -11,12 +11,16 @@ obj-y     = sched.o fork.o exec_domain.o
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
 
+CFLAGS_REMOVE_sched.o = -pg -mno-spe
+
 ifdef CONFIG_FTRACE
-# Do not profile debug utilities
-ORIG_CFLAGS := $(KBUILD_CFLAGS)
-KBUILD_CFLAGS = $(if $(filter-out lockdep% %debug sched_clock,$(basename $(notdir $@))), \
-	$(ORIG_CFLAGS), \
-	$(subst -pg,,$(ORIG_CFLAGS)))
+# Do not trace debug files and internal ftrace files
+CFLAGS_REMOVE_lockdep.o = -pg
+CFLAGS_REMOVE_lockdep_proc.o = -pg
+CFLAGS_REMOVE_mutex-debug.o = -pg
+CFLAGS_REMOVE_rtmutex-debug.o = -pg
+CFLAGS_REMOVE_cgroup-debug.o = -pg
+CFLAGS_REMOVE_sched_clock.o = -pg
 endif
 
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o

-- 
