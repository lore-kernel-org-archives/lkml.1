Return-Path: <linux-kernel-owner+w=401wt.eu-S1762348AbZLPRGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762348AbZLPRGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762287AbZLPRGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762255AbZLPRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:17 -0500
Message-Id: <20091216170517.423469527@chello.nl>
References: <20091216170430.073353839@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 18:04:31 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/12] sched: Mark boot-cpu active before smp_init()
Content-Disposition: inline; filename=foo12.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A UP machine has 1 active cpu, not having the boot-cpu in the active
map when starting the scheduler confuses things.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -369,12 +369,6 @@ static void __init smp_init(void)
 {
 	unsigned int cpu;
 
-	/*
-	 * Set up the current CPU as possible to migrate to.
-	 * The other ones will be done by cpu_up/cpu_down()
-	 */
-	set_cpu_active(smp_processor_id(), true);
-
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
@@ -486,6 +480,7 @@ static void __init boot_cpu_init(void)
 	int cpu = smp_processor_id();
 	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
 	set_cpu_online(cpu, true);
+	set_cpu_active(cpu, true);
 	set_cpu_present(cpu, true);
 	set_cpu_possible(cpu, true);
 }

-- 

