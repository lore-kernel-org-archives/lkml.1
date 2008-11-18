Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbYKRNRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbYKRNRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 08:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYKRNRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 08:17:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:37785 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbYKRNRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:17:39 -0500
Date: Tue, 18 Nov 2008 07:17:24 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Greg KH <greg@kroah.com>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH][for 2.6.27/stable] Remove -mno-spe flags as they dont belong
Message-ID: <Pine.LNX.4.64.0811180717180.28154@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

(This is backported for commit 65ecc14a30ad21bed9aabdfd6a2ae1a1aaaa6a00)

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Tested-and-Acked-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

Greg,

A straight cherry pick of 65ecc14a30ad21bed9aabdfd6a2ae1a1aaaa6a00 causes
merge issues with 2.6.27.x, so there here is a version of the commit that
should apply to 2.6.27.x

- k


 kernel/Makefile |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 4e1d7df..143e8b6 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -11,8 +11,6 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o

-CFLAGS_REMOVE_sched.o = -mno-spe
-
 ifdef CONFIG_FTRACE
 # Do not trace debug files and internal ftrace files
 CFLAGS_REMOVE_lockdep.o = -pg
@@ -21,7 +19,7 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
-CFLAGS_REMOVE_sched.o = -mno-spe -pg
+CFLAGS_REMOVE_sched.o = -pg
 endif

 obj-$(CONFIG_PROFILING) += profile.o
-- 
1.5.6.5

