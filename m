Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbZB0TD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbZB0TD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 14:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbZB0TDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 14:03:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:60741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbZB0TDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 14:03:18 -0500
Subject: [PATCH -tip] x86: remove double copy of show_cpuinfo_core for 32
 and 64 bit
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 28 Feb 2009 00:32:41 +0530
Message-Id: <1235761361.7332.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


show_cpuinfo_core copy is unnecessary for 32 and 64 bit
and CONFIG_X86_HT depends on CONFIG_X86_SMP

Impact: cleanup

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/proc.c |   20 ++------------------
 1 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 01b1244..d67e0e4 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -7,11 +7,10 @@
 /*
  *	Get CPU information for use by the procfs.
  */
-#ifdef CONFIG_X86_32
 static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 			      unsigned int cpu)
 {
-#ifdef CONFIG_X86_HT
+#ifdef CONFIG_SMP
 	if (c->x86_max_cores * smp_num_siblings > 1) {
 		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
 		seq_printf(m, "siblings\t: %d\n",
@@ -24,6 +23,7 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 #endif
 }
 
+#ifdef CONFIG_X86_32
 static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 {
 	/*
@@ -50,22 +50,6 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   c->wp_works_ok ? "yes" : "no");
 }
 #else
-static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
-			      unsigned int cpu)
-{
-#ifdef CONFIG_SMP
-	if (c->x86_max_cores * smp_num_siblings > 1) {
-		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
-		seq_printf(m, "siblings\t: %d\n",
-			   cpus_weight(per_cpu(cpu_core_map, cpu)));
-		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
-		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
-		seq_printf(m, "apicid\t\t: %d\n", c->apicid);
-		seq_printf(m, "initial apicid\t: %d\n", c->initial_apicid);
-	}
-#endif
-}
-
 static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 {
 	seq_printf(m,
-- 
1.6.0.6



