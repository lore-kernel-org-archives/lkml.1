Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbZKCEYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbZKCEYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbZKCEYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:24:07 -0500
Received: from ozlabs.org ([203.10.76.45]:48148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460AbZKCEYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:24:05 -0500
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911031454.09261.rusty@rustcorp.com.au>
Date: Tue, 3 Nov 2009 14:54:09 +1030
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/14] cpumask: use struct cpumask rather than the deprecated cpumask_t
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/msr.h |    4 ++--
 arch/x86/lib/msr.c         |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -247,8 +247,8 @@ do {                                    
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
-void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
-void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
+void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8]);
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -78,7 +78,7 @@ EXPORT_SYMBOL(wrmsr_on_cpu);
  * @msrs:       array of MSR values
  *
  */
-void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
+void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
 {
 	struct msr_info rv;
 	int this_cpu;
@@ -107,7 +107,7 @@ EXPORT_SYMBOL(rdmsr_on_cpus);
  * @msrs:       array of MSR values
  *
  */
-void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
 {
 	struct msr_info rv;
 	int this_cpu;

