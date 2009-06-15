Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZFOOWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZFOOWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZFOOWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:22:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:47399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbZFOOWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:22:14 -0400
Date: Mon, 15 Jun 2009 14:21:43 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       vapier.adi@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, vapier.adi@gmail.com, mingo@elte.hu
In-Reply-To: <18998.13388.920691.523227@cargo.ozlabs.ibm.com>
References: <18998.13388.920691.523227@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: Make set_perf_counter_pending() declaration common
Message-ID: <tip-9974458e2f9a11dbd2f4bd14fab5a79af4907b41@git.kernel.org>
Git-Commit-ID: 9974458e2f9a11dbd2f4bd14fab5a79af4907b41
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Jun 2009 14:21:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9974458e2f9a11dbd2f4bd14fab5a79af4907b41
Gitweb:     http://git.kernel.org/tip/9974458e2f9a11dbd2f4bd14fab5a79af4907b41
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 15 Jun 2009 21:45:16 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 15 Jun 2009 16:12:26 +0200

perf_counter: Make set_perf_counter_pending() declaration common

At present, every architecture that supports perf_counters has to
declare set_perf_counter_pending() in its arch-specific headers.
This consolidates the declarations into a single declaration in one
common place, include/linux/perf_counter.h.  On powerpc, we continue
to provide a static inline definition of set_perf_counter_pending()
in the powerpc hw_irq.h.

Also, this removes from the x86 perf_counter.h the unused null
definitions of {test,clear}_perf_counter_pending.

Reported-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: benh@kernel.crashing.org
LKML-Reference: <18998.13388.920691.523227@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/include/asm/hw_irq.h       |    1 -
 arch/powerpc/include/asm/perf_counter.h |    2 ++
 arch/x86/include/asm/perf_counter.h     |    5 -----
 include/linux/perf_counter.h            |    1 +
 4 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index 5351237..1974cf1 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -163,7 +163,6 @@ static inline unsigned long test_perf_counter_pending(void)
 	return 0;
 }
 
-static inline void set_perf_counter_pending(void) {}
 static inline void clear_perf_counter_pending(void) {}
 #endif /* CONFIG_PERF_COUNTERS */
 
diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index cc7c887..b398a84 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -10,6 +10,8 @@
  */
 #include <linux/types.h>
 
+#include <asm/hw_irq.h>
+
 #define MAX_HWCOUNTERS		8
 #define MAX_EVENT_ALTERNATIVES	8
 #define MAX_LIMITED_HWCOUNTERS	2
diff --git a/arch/x86/include/asm/perf_counter.h b/arch/x86/include/asm/perf_counter.h
index 876ed97..5fb33e1 100644
--- a/arch/x86/include/asm/perf_counter.h
+++ b/arch/x86/include/asm/perf_counter.h
@@ -84,11 +84,6 @@ union cpuid10_edx {
 #define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
 #define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
 
-extern void set_perf_counter_pending(void);
-
-#define clear_perf_counter_pending()	do { } while (0)
-#define test_perf_counter_pending()	(0)
-
 #ifdef CONFIG_PERF_COUNTERS
 extern void init_hw_perf_counters(void);
 extern void perf_counters_lapic_init(void);
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 1b3118a..eccae43 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -604,6 +604,7 @@ extern void perf_counter_task_tick(struct task_struct *task, int cpu);
 extern int perf_counter_init_task(struct task_struct *child);
 extern void perf_counter_exit_task(struct task_struct *child);
 extern void perf_counter_free_task(struct task_struct *task);
+extern void set_perf_counter_pending(void);
 extern void perf_counter_do_pending(void);
 extern void perf_counter_print_debug(void);
 extern void __perf_disable(void);
