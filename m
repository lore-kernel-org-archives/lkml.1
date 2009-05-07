Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbZEGJU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbZEGJU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbZEGJUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:20:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:40238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987AbZEGJUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:20:45 -0400
Date: Thu, 7 May 2009 09:19:58 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:x86/cleanups] x86: clean up arch/x86/kernel/tsc_sync.c a bit
Message-ID: <tip-643bec956544d376b7c2a80a3d5c3d0bf94da8d3@git.kernel.org>
Git-Commit-ID: 643bec956544d376b7c2a80a3d5c3d0bf94da8d3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:20:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  643bec956544d376b7c2a80a3d5c3d0bf94da8d3
Gitweb:     http://git.kernel.org/tip/643bec956544d376b7c2a80a3d5c3d0bf94da8d3
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 7 May 2009 09:12:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 7 May 2009 09:32:10 +0200

x86: clean up arch/x86/kernel/tsc_sync.c a bit

 - remove unused define
 - make the lock variable definition stand out some more
 - convert KERN_* to pr_info() / pr_warning()

[ Impact: cleanup ]

LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/tsc_sync.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index bf36328..027b5b4 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -34,6 +34,7 @@ static __cpuinitdata atomic_t stop_count;
  * of a critical section, to be able to prove TSC time-warps:
  */
 static __cpuinitdata raw_spinlock_t sync_lock = __RAW_SPIN_LOCK_UNLOCKED;
+
 static __cpuinitdata cycles_t last_tsc;
 static __cpuinitdata cycles_t max_warp;
 static __cpuinitdata int nr_warps;
@@ -113,13 +114,12 @@ void __cpuinit check_tsc_sync_source(int cpu)
 		return;
 
 	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
-		printk(KERN_INFO
-		       "Skipping synchronization checks as TSC is reliable.\n");
+		pr_info("Skipping synchronization checks as TSC is reliable.\n");
 		return;
 	}
 
-	printk(KERN_INFO "checking TSC synchronization [CPU#%d -> CPU#%d]:",
-			  smp_processor_id(), cpu);
+	pr_info("checking TSC synchronization [CPU#%d -> CPU#%d]:",
+		smp_processor_id(), cpu);
 
 	/*
 	 * Reset it - in case this is a second bootup:
@@ -143,8 +143,8 @@ void __cpuinit check_tsc_sync_source(int cpu)
 
 	if (nr_warps) {
 		printk("\n");
-		printk(KERN_WARNING "Measured %Ld cycles TSC warp between CPUs,"
-				    " turning off TSC clock.\n", max_warp);
+		pr_warning("Measured %Ld cycles TSC warp between CPUs, "
+			   "turning off TSC clock.\n", max_warp);
 		mark_tsc_unstable("check_tsc_sync_source failed");
 	} else {
 		printk(" passed.\n");
@@ -195,5 +195,3 @@ void __cpuinit check_tsc_sync_target(void)
 	while (atomic_read(&stop_count) != cpus)
 		cpu_relax();
 }
-#undef NR_LOOPS
-
