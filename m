Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbXEGXCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbXEGXCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 19:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbXEGXCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 19:02:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:9444 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbXEGXCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 19:02:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="243100021"
Date: Mon, 7 May 2007 15:59:44 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, clameter@sgi.com
Cc: fenghua.yu@intel.com
Subject: Re: [PATCH 2/2] Call percpu smp cacheline algin interface
Message-ID: <20070507225944.GA15372@linux-os.sc.intel.com>
References: <33E1C72C74DBE747B7B59C1740F7443701A2F0AB@orsmsx417.amr.corp.intel.com> <20070505001231.GA27263@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505001231.GA27263@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 05:12:31PM -0700, Fenghua Yu wrote:
> 
> Call percpu smp cacheline align interface.
> 

This is updated patch. Use new macro name DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED for better code understanding.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

---

 arch/i386/kernel/init_task.c   |    2 +-
 arch/i386/kernel/irq.c         |    2 +-
 arch/ia64/kernel/smp.c         |    2 +-
 arch/x86_64/kernel/init_task.c |    2 +-
 kernel/sched.c                 |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)
 
diff -Nurp linux-2.6.21-rc7.0/arch/i386/kernel/init_task.c linux-2.6.21-rc7.1/arch/i386/kernel/init_task.c
--- linux-2.6.21-rc7.0/arch/i386/kernel/init_task.c	2007-04-15 16:50:57.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/i386/kernel/init_task.c	2007-05-02 17:00:34.000000000 -0700
@@ -42,5 +42,5 @@ EXPORT_SYMBOL(init_task);
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's.
  */ 
-DEFINE_PER_CPU(struct tss_struct, init_tss) ____cacheline_internodealigned_in_smp = INIT_TSS;
+DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
 
diff -Nurp linux-2.6.21-rc7.0/arch/i386/kernel/irq.c linux-2.6.21-rc7.1/arch/i386/kernel/irq.c
--- linux-2.6.21-rc7.0/arch/i386/kernel/irq.c	2007-05-01 07:32:59.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/i386/kernel/irq.c	2007-05-02 17:00:34.000000000 -0700
@@ -21,7 +21,7 @@
 #include <asm/apic.h>
 #include <asm/uaccess.h>
 
-DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
+DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 
 DEFINE_PER_CPU(struct pt_regs *, irq_regs);
diff -Nurp linux-2.6.21-rc7.0/arch/ia64/kernel/smp.c linux-2.6.21-rc7.1/arch/ia64/kernel/smp.c
--- linux-2.6.21-rc7.0/arch/ia64/kernel/smp.c	2007-04-15 16:50:57.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/ia64/kernel/smp.c	2007-05-02 17:00:34.000000000 -0700
@@ -70,7 +70,7 @@ static volatile struct call_data_struct 
 #define IPI_KDUMP_CPU_STOP	3
 
 /* This needs to be cacheline aligned because it is written to by *other* CPUs.  */
-static DEFINE_PER_CPU(u64, ipi_operation) ____cacheline_aligned;
+static DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(u64, ipi_operation);
 
 extern void cpu_halt (void);
 
diff -Nurp linux-2.6.21-rc7.0/arch/x86_64/kernel/init_task.c linux-2.6.21-rc7.1/arch/x86_64/kernel/init_task.c
--- linux-2.6.21-rc7.0/arch/x86_64/kernel/init_task.c	2007-04-15 16:50:57.000000000 -0700
+++ linux-2.6.21-rc7.1/arch/x86_64/kernel/init_task.c	2007-05-02 17:00:34.000000000 -0700
@@ -44,7 +44,7 @@ EXPORT_SYMBOL(init_task);
  * section. Since TSS's are completely CPU-local, we want them
  * on exact cacheline boundaries, to eliminate cacheline ping-pong.
  */ 
-DEFINE_PER_CPU(struct tss_struct, init_tss) ____cacheline_internodealigned_in_smp = INIT_TSS;
+DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
 
 /* Copies of the original ist values from the tss are only accessed during
  * debugging, no special alignment required.
diff -Nurp linux-2.6.21-rc7.0/kernel/sched.c linux-2.6.21-rc7.1/kernel/sched.c
--- linux-2.6.21-rc7.0/kernel/sched.c	2007-05-01 07:33:07.000000000 -0700
+++ linux-2.6.21-rc7.1/kernel/sched.c	2007-05-02 17:00:34.000000000 -0700
@@ -263,7 +263,7 @@ struct rq {
 	struct lock_class_key rq_lock_key;
 };
 
-static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU_SHARED_CACHELINE_ALIGNED(struct rq, runqueues);
 static DEFINE_MUTEX(sched_hotcpu_mutex);
 
 static inline int cpu_of(struct rq *rq)
