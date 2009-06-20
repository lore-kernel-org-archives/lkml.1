Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbZFTR0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbZFTR0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 13:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZFTR0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 13:26:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34016 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZFTR0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 13:26:40 -0400
Date: Sat, 20 Jun 2009 19:26:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] IRQ fixes
Message-ID: <20090620172632.GA12660@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Randy Dunlap (1):
      genirq, irq.h: Fix kernel-doc warnings

Steven Rostedt (1):
      genirq: fix comment to say IRQ_WAKE_THREAD


 include/linux/irq.h |    4 ++--
 kernel/irq/manage.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index b7cbeed..0c001c1 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -157,7 +157,7 @@ struct irq_2_iommu;
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @lock:		locking for SMP
  * @affinity:		IRQ affinity on SMP
- * @cpu:		cpu index useful for balancing
+ * @node:		node index useful for balancing
  * @pending_mask:	pending rebalanced interrupts
  * @threads_active:	number of irqaction threads currently running
  * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
@@ -426,7 +426,7 @@ extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
 /**
  * init_alloc_desc_masks - allocate cpumasks for irq_desc
  * @desc:	pointer to irq_desc struct
- * @cpu:	cpu which will be handling the cpumasks
+ * @node:	node which will be handling the cpumasks
  * @boot:	true if need bootmem
  *
  * Allocates affinity and pending_mask cpumask if required.
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2734eca..eb47f8b 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -851,7 +851,7 @@ EXPORT_SYMBOL(free_irq);
  *	still called in hard interrupt context and has to check
  *	whether the interrupt originates from the device. If yes it
  *	needs to disable the interrupt on the device and return
- *	IRQ_THREAD_WAKE which will wake up the handler thread and run
+ *	IRQ_WAKE_THREAD which will wake up the handler thread and run
  *	@thread_fn. This split handler design is necessary to support
  *	shared interrupts.
  *
