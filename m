Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZCHKOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZCHKOe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZCHKO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:14:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:50935 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZCHKOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:14:25 -0400
Subject: [git-pull -tip] x86:perf_counter cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 15:43:52 +0530
Message-Id: <1236507232.28127.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 880860e392d92c457e8116cdee39ec4d109174ee:
  Paul Mackerras (1):
        perfcounters/powerpc: add support for POWER4 processors

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git perfcounters/core

Jaswinder Singh Rajput (2):
      x86: perf_counter.c remove unused variables
      x86: perf_counter.c fix style problems

 arch/x86/kernel/cpu/perf_counter.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index f585371..7460895 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -17,7 +17,6 @@
 #include <linux/kdebug.h>
 #include <linux/sched.h>
 
-#include <asm/perf_counter.h>
 #include <asm/apic.h>
 
 static bool perf_counters_initialized __read_mostly;
@@ -263,6 +262,9 @@ static u64 pmc_amd_save_disable_all(void)
 	return enabled;
 }
 
+/*
+ * Exported because of ACPI idle
+ */
 u64 hw_perf_save_disable(void)
 {
 	if (unlikely(!perf_counters_initialized))
@@ -270,9 +272,6 @@ u64 hw_perf_save_disable(void)
 
 	return pmc_ops->save_disable_all();
 }
-/*
- * Exported because of ACPI idle
- */
 EXPORT_SYMBOL_GPL(hw_perf_save_disable);
 
 static void pmc_intel_restore_all(u64 ctrl)
@@ -301,6 +300,9 @@ static void pmc_amd_restore_all(u64 ctrl)
 	}
 }
 
+/*
+ * Exported because of ACPI idle
+ */
 void hw_perf_restore(u64 ctrl)
 {
 	if (unlikely(!perf_counters_initialized))
@@ -308,9 +310,6 @@ void hw_perf_restore(u64 ctrl)
 
 	pmc_ops->restore_all(ctrl);
 }
-/*
- * Exported because of ACPI idle
- */
 EXPORT_SYMBOL_GPL(hw_perf_restore);
 
 static u64 pmc_intel_get_status(u64 mask)
@@ -954,9 +953,6 @@ static struct pmc_x86_ops *pmc_intel_init(void)
 
 static struct pmc_x86_ops *pmc_amd_init(void)
 {
-	u64 old;
-	int bits;
-
 	nr_counters_generic = 4;
 	nr_counters_fixed = 0;
 	counter_value_mask = 0x0000FFFFFFFFFFFFULL;


