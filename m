Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYKOSDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYKOSDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 13:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYKOSDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 13:03:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:38928 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbYKOSDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 13:03:00 -0500
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>, srostedt@redhat.com
Subject: [PATCH][for 2.6.28] Remove -mno-spe flags as they dont belong
Date: Sat, 15 Nov 2008 12:02:34 -0600
Message-Id: <1226772154-6109-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some unknown reason at Steven Rostedt added in disabling of the SPE
instruction generation for e500 based PPC cores in commit
6ec562328fda585be2d7f472cfac99d3b44d362a.

We are removing it because:

1. It generates e500 kernels that don't work
2. its not the correct set of flags to do this
3. we handle this in the arch/powerpc/Makefile already
4. its unknown in talking to Steven why he did this

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 kernel/Makefile |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 9a3ec66..19fad00 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -11,8 +11,6 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
 
-CFLAGS_REMOVE_sched.o = -mno-spe
-
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
 CFLAGS_REMOVE_lockdep.o = -pg
@@ -21,7 +19,7 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
-CFLAGS_REMOVE_sched.o = -mno-spe -pg
+CFLAGS_REMOVE_sched.o = -pg
 endif
 
 obj-$(CONFIG_FREEZER) += freezer.o
-- 
1.5.6.5

