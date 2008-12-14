Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYLNUws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYLNUws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 15:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYLNUwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 15:52:40 -0500
Received: from relay3.ptmail.sapo.pt ([212.55.154.23]:59783 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750719AbYLNUwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 15:52:39 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Sun, 14 Dec 2008 20:52:18 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <pzijlstr@redhat.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Conditional compilation updates in kernel/lockdep.c
Message-ID: <20081214205218.GA10877@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following warning:

kernel/lockdep.c:580: warning: ‘print_lock_dependencies’ defined but not used

Now functions print_lock_dependencies and print_lock_class_header are now
compiled only if both CONFIG_TRACE_IRQFLAGS and CONFIG_PROVE_LOCKING
are defined; function lockdep_dependency_visit and variable
lockdep_dependency_gen_id are compiled only if CONFIG_PROVE_LOCKING
is defined

Signed-off-by: Luis Henriques <henrix@sapo.pt>
---
 kernel/lockdep.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 46a4041..f2eebc7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -381,6 +381,7 @@ unsigned int nr_process_chains;
 unsigned int max_lockdep_depth;
 unsigned int max_recursion_depth;
 
+#ifdef CONFIG_PROVE_LOCKING
 static unsigned int lockdep_dependency_gen_id;
 
 static bool lockdep_dependency_visit(struct lock_class *source,
@@ -393,6 +394,7 @@ static bool lockdep_dependency_visit(struct lock_class *source,
 	source->dep_gen_id = lockdep_dependency_gen_id;
 	return false;
 }
+#endif
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
@@ -549,6 +551,8 @@ static void lockdep_print_held_locks(struct task_struct *curr)
 	}
 }
 
+#if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_PROVE_LOCKING)
+
 static void print_lock_class_header(struct lock_class *class, int depth)
 {
 	int bit;
@@ -599,6 +603,7 @@ static void print_lock_dependencies(struct lock_class *class, int depth)
 		printk("\n");
 	}
 }
+#endif
 
 static void print_kernel_version(void)
 {
-- 
Luis Henriques

