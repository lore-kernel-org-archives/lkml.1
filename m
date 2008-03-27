Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbYC0RLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbYC0RLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbYC0RK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:10:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbYC0RKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:10:55 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 8/9] [PATCH] x86: change naming of cpu_initialized_mask for xen
Date: Thu, 27 Mar 2008 14:06:03 -0300
Message-Id: <12066375973688-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12066375644061-git-send-email-gcosta@redhat.com>
References: <12066375644061-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen does not use the global cpu_initialized mask, but rather,
a specific one. So we change its name so it won't conflict with the upcoming
movement of cpu_initialized_mask from smp_64.h to smp_32.h.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/xen/smp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 6b3c37b..92dd3db 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -35,7 +35,7 @@
 #include "xen-ops.h"
 #include "mmu.h"
 
-static cpumask_t cpu_initialized_map;
+static cpumask_t xen_cpu_initialized_map;
 static DEFINE_PER_CPU(int, resched_irq) = -1;
 static DEFINE_PER_CPU(int, callfunc_irq) = -1;
 static DEFINE_PER_CPU(int, debug_irq) = -1;
@@ -189,7 +189,7 @@ void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 	if (xen_smp_intr_init(0))
 		BUG();
 
-	cpu_initialized_map = cpumask_of_cpu(0);
+	xen_cpu_initialized_map = cpumask_of_cpu(0);
 
 	/* Restrict the possible_map according to max_cpus. */
 	while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
@@ -220,7 +220,7 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	struct vcpu_guest_context *ctxt;
 	struct gdt_page *gdt = &per_cpu(gdt_page, cpu);
 
-	if (cpu_test_and_set(cpu, cpu_initialized_map))
+	if (cpu_test_and_set(cpu, xen_cpu_initialized_map))
 		return 0;
 
 	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
-- 
1.5.0.6

