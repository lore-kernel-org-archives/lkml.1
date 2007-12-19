Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbXLSXEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbXLSXEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXLSXEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:04:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35010 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbXLSXEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:04:39 -0500
Date: Thu, 20 Dec 2007 00:04:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20071219230420.GA14546@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

5 fixes. Thanks!

	Ingo

------------------>
Adrian Bunk (4):
      x86 apic_32.c section fix
      x86 smpboot_32.c section fixes
      x86_32: select_idle_routine() must be __cpuinit
      x86_32: disable_pse must be __cpuinitdata

Mike Travis (1):
      x86: fix show cpuinfo cpu number always zero

 apic_32.c    |    2 +-
 process_32.c |    2 +-
 setup_32.c   |    2 +-
 smpboot_32.c |    6 +++---
 smpboot_64.c |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 96986b4..edb5108 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -849,7 +849,7 @@ void __init init_bsp_APIC(void)
 /**
  * setup_local_APIC - setup the local APIC
  */
-void __devinit setup_local_APIC(void)
+void __cpuinit setup_local_APIC(void)
 {
 	unsigned long oldvalue, value, maxlvt, integrated;
 	int i, j;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7b89958..9663c2a 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -261,7 +261,7 @@ static void mwait_idle(void)
 	mwait_idle_with_hints(0, 0);
 }
 
-void __devinit select_idle_routine(const struct cpuinfo_x86 *c)
+void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_MWAIT)) {
 		printk("monitor/mwait feature present.\n");
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index e1e18c3..9c24b45 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -67,7 +67,7 @@
    address, and must not be in the .bss segment! */
 unsigned long init_pg_tables_end __initdata = ~0UL;
 
-int disable_pse __devinitdata = 0;
+int disable_pse __cpuinitdata = 0;
 
 /*
  * Machine setup..
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index ef0f34e..4ea80cb 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -60,7 +60,7 @@
 #include <asm/mtrr.h>
 
 /* Set if we find a B stepping CPU */
-static int __devinitdata smp_b_stepping;
+static int __cpuinitdata smp_b_stepping;
 
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
@@ -745,8 +745,8 @@ static inline int alloc_cpu_id(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static struct task_struct * __devinitdata cpu_idle_tasks[NR_CPUS];
-static inline struct task_struct * alloc_idle_task(int cpu)
+static struct task_struct * __cpuinitdata cpu_idle_tasks[NR_CPUS];
+static inline struct task_struct * __cpuinit alloc_idle_task(int cpu)
 {
 	struct task_struct *idle;
 
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 500670c..5948895 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -141,8 +141,8 @@ static void __cpuinit smp_store_cpu_info(int id)
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
 	*c = boot_cpu_data;
-	c->cpu_index = id;
 	identify_cpu(c);
+	c->cpu_index = id;
 	print_cpu_info(c);
 }
 
