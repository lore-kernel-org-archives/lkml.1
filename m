Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbZLJIoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbZLJIoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbZLJIoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:44:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:51728 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758862AbZLJIn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:43:59 -0500
Date: Thu, 10 Dec 2009 08:43:34 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <009cb214c45ef932df0242856228f4739cc91408.1260383912.git.joe@perches.com>
References: <009cb214c45ef932df0242856228f4739cc91408.1260383912.git.joe@perches.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: mmio-mod.c: Use pr_fmt
Message-ID: <tip-3a0340be06a9356eb61f6804107480acbe62c069@git.kernel.org>
Git-Commit-ID: 3a0340be06a9356eb61f6804107480acbe62c069
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a0340be06a9356eb61f6804107480acbe62c069
Gitweb:     http://git.kernel.org/tip/3a0340be06a9356eb61f6804107480acbe62c069
Author:     Joe Perches <joe@perches.com>
AuthorDate: Wed, 9 Dec 2009 10:45:37 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 08:57:51 +0100

x86: mmio-mod.c: Use pr_fmt

- Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 - Remove #define NAME
 - Remove NAME from pr_<level>

Signed-off-by: Joe Perches <joe@perches.com>
LKML-Reference: <009cb214c45ef932df0242856228f4739cc91408.1260383912.git.joe@perches.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/mmio-mod.c |   71 +++++++++++++++++++++++------------------------
 1 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 132772a..4c765e9 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -19,6 +19,9 @@
  *
  * Derived from the read-mod example from relay-examples by Tom Zanussi.
  */
+
+#define pr_fmt(fmt) "mmiotrace: "
+
 #define DEBUG 1
 
 #include <linux/module.h>
@@ -36,8 +39,6 @@
 
 #include "pf_in.h"
 
-#define NAME "mmiotrace: "
-
 struct trap_reason {
 	unsigned long addr;
 	unsigned long ip;
@@ -96,17 +97,18 @@ static void print_pte(unsigned long address)
 	pte_t *pte = lookup_address(address, &level);
 
 	if (!pte) {
-		pr_err(NAME "Error in %s: no pte for page 0x%08lx\n",
-							__func__, address);
+		pr_err("Error in %s: no pte for page 0x%08lx\n",
+		       __func__, address);
 		return;
 	}
 
 	if (level == PG_LEVEL_2M) {
-		pr_emerg(NAME "4MB pages are not currently supported: "
-							"0x%08lx\n", address);
+		pr_emerg("4MB pages are not currently supported: 0x%08lx\n",
+			 address);
 		BUG();
 	}
-	pr_info(NAME "pte for 0x%lx: 0x%llx 0x%llx\n", address,
+	pr_info("pte for 0x%lx: 0x%llx 0x%llx\n",
+		address,
 		(unsigned long long)pte_val(*pte),
 		(unsigned long long)pte_val(*pte) & _PAGE_PRESENT);
 }
@@ -118,22 +120,21 @@ static void print_pte(unsigned long address)
 static void die_kmmio_nesting_error(struct pt_regs *regs, unsigned long addr)
 {
 	const struct trap_reason *my_reason = &get_cpu_var(pf_reason);
-	pr_emerg(NAME "unexpected fault for address: 0x%08lx, "
-					"last fault for address: 0x%08lx\n",
-					addr, my_reason->addr);
+	pr_emerg("unexpected fault for address: 0x%08lx, last fault for address: 0x%08lx\n",
+		 addr, my_reason->addr);
 	print_pte(addr);
 	print_symbol(KERN_EMERG "faulting IP is at %s\n", regs->ip);
 	print_symbol(KERN_EMERG "last faulting IP was at %s\n", my_reason->ip);
 #ifdef __i386__
 	pr_emerg("eax: %08lx   ebx: %08lx   ecx: %08lx   edx: %08lx\n",
-			regs->ax, regs->bx, regs->cx, regs->dx);
+		 regs->ax, regs->bx, regs->cx, regs->dx);
 	pr_emerg("esi: %08lx   edi: %08lx   ebp: %08lx   esp: %08lx\n",
-			regs->si, regs->di, regs->bp, regs->sp);
+		 regs->si, regs->di, regs->bp, regs->sp);
 #else
 	pr_emerg("rax: %016lx   rcx: %016lx   rdx: %016lx\n",
-					regs->ax, regs->cx, regs->dx);
+		 regs->ax, regs->cx, regs->dx);
 	pr_emerg("rsi: %016lx   rdi: %016lx   rbp: %016lx   rsp: %016lx\n",
-				regs->si, regs->di, regs->bp, regs->sp);
+		 regs->si, regs->di, regs->bp, regs->sp);
 #endif
 	put_cpu_var(pf_reason);
 	BUG();
@@ -213,7 +214,7 @@ static void post(struct kmmio_probe *p, unsigned long condition,
 	/* this should always return the active_trace count to 0 */
 	my_reason->active_traces--;
 	if (my_reason->active_traces) {
-		pr_emerg(NAME "unexpected post handler");
+		pr_emerg("unexpected post handler");
 		BUG();
 	}
 
@@ -244,7 +245,7 @@ static void ioremap_trace_core(resource_size_t offset, unsigned long size,
 	};
 
 	if (!trace) {
-		pr_err(NAME "kmalloc failed in ioremap\n");
+		pr_err("kmalloc failed in ioremap\n");
 		return;
 	}
 
@@ -282,8 +283,8 @@ void mmiotrace_ioremap(resource_size_t offset, unsigned long size,
 	if (!is_enabled()) /* recheck and proper locking in *_core() */
 		return;
 
-	pr_debug(NAME "ioremap_*(0x%llx, 0x%lx) = %p\n",
-				(unsigned long long)offset, size, addr);
+	pr_debug("ioremap_*(0x%llx, 0x%lx) = %p\n",
+		 (unsigned long long)offset, size, addr);
 	if ((filter_offset) && (offset != filter_offset))
 		return;
 	ioremap_trace_core(offset, size, addr);
@@ -301,7 +302,7 @@ static void iounmap_trace_core(volatile void __iomem *addr)
 	struct remap_trace *tmp;
 	struct remap_trace *found_trace = NULL;
 
-	pr_debug(NAME "Unmapping %p.\n", addr);
+	pr_debug("Unmapping %p.\n", addr);
 
 	spin_lock_irq(&trace_lock);
 	if (!is_enabled())
@@ -363,9 +364,8 @@ static void clear_trace_list(void)
 	 * Caller also ensures is_enabled() cannot change.
 	 */
 	list_for_each_entry(trace, &trace_list, list) {
-		pr_notice(NAME "purging non-iounmapped "
-					"trace @0x%08lx, size 0x%lx.\n",
-					trace->probe.addr, trace->probe.len);
+		pr_notice("purging non-iounmapped trace @0x%08lx, size 0x%lx.\n",
+			  trace->probe.addr, trace->probe.len);
 		if (!nommiotrace)
 			unregister_kmmio_probe(&trace->probe);
 	}
@@ -387,7 +387,7 @@ static void enter_uniprocessor(void)
 
 	if (downed_cpus == NULL &&
 	    !alloc_cpumask_var(&downed_cpus, GFP_KERNEL)) {
-		pr_notice(NAME "Failed to allocate mask\n");
+		pr_notice("Failed to allocate mask\n");
 		goto out;
 	}
 
@@ -395,20 +395,19 @@ static void enter_uniprocessor(void)
 	cpumask_copy(downed_cpus, cpu_online_mask);
 	cpumask_clear_cpu(cpumask_first(cpu_online_mask), downed_cpus);
 	if (num_online_cpus() > 1)
-		pr_notice(NAME "Disabling non-boot CPUs...\n");
+		pr_notice("Disabling non-boot CPUs...\n");
 	put_online_cpus();
 
 	for_each_cpu(cpu, downed_cpus) {
 		err = cpu_down(cpu);
 		if (!err)
-			pr_info(NAME "CPU%d is down.\n", cpu);
+			pr_info("CPU%d is down.\n", cpu);
 		else
-			pr_err(NAME "Error taking CPU%d down: %d\n", cpu, err);
+			pr_err("Error taking CPU%d down: %d\n", cpu, err);
 	}
 out:
 	if (num_online_cpus() > 1)
-		pr_warning(NAME "multiple CPUs still online, "
-						"may miss events.\n");
+		pr_warning("multiple CPUs still online, may miss events.\n");
 }
 
 /* __ref because leave_uniprocessor calls cpu_up which is __cpuinit,
@@ -420,13 +419,13 @@ static void __ref leave_uniprocessor(void)
 
 	if (downed_cpus == NULL || cpumask_weight(downed_cpus) == 0)
 		return;
-	pr_notice(NAME "Re-enabling CPUs...\n");
+	pr_notice("Re-enabling CPUs...\n");
 	for_each_cpu(cpu, downed_cpus) {
 		err = cpu_up(cpu);
 		if (!err)
-			pr_info(NAME "enabled CPU%d.\n", cpu);
+			pr_info("enabled CPU%d.\n", cpu);
 		else
-			pr_err(NAME "cannot re-enable CPU%d: %d\n", cpu, err);
+			pr_err("cannot re-enable CPU%d: %d\n", cpu, err);
 	}
 }
 
@@ -434,8 +433,8 @@ static void __ref leave_uniprocessor(void)
 static void enter_uniprocessor(void)
 {
 	if (num_online_cpus() > 1)
-		pr_warning(NAME "multiple CPUs are online, may miss events. "
-			"Suggest booting with maxcpus=1 kernel argument.\n");
+		pr_warning("multiple CPUs are online, may miss events. "
+			   "Suggest booting with maxcpus=1 kernel argument.\n");
 }
 
 static void leave_uniprocessor(void)
@@ -450,13 +449,13 @@ void enable_mmiotrace(void)
 		goto out;
 
 	if (nommiotrace)
-		pr_info(NAME "MMIO tracing disabled.\n");
+		pr_info("MMIO tracing disabled.\n");
 	kmmio_init();
 	enter_uniprocessor();
 	spin_lock_irq(&trace_lock);
 	atomic_inc(&mmiotrace_enabled);
 	spin_unlock_irq(&trace_lock);
-	pr_info(NAME "enabled.\n");
+	pr_info("enabled.\n");
 out:
 	mutex_unlock(&mmiotrace_mutex);
 }
@@ -475,7 +474,7 @@ void disable_mmiotrace(void)
 	clear_trace_list(); /* guarantees: no more kmmio callbacks */
 	leave_uniprocessor();
 	kmmio_cleanup();
-	pr_info(NAME "disabled.\n");
+	pr_info("disabled.\n");
 out:
 	mutex_unlock(&mmiotrace_mutex);
 }
