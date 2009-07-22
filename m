Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbZGVVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbZGVVWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZGVVWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:22:17 -0400
Received: from www.tglx.de ([62.245.132.106]:40530 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbZGVVWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:22:16 -0400
Date: Wed, 22 Jul 2009 23:22:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] irq fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0907222320490.2813@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

Thanks,

	tglx (hiding in a full body sized brown paperbag)

------------------>
Bruno Premont (1):
      genirq: Fix UP compile failure caused by irq_thread_check_affinity


 kernel/irq/manage.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f0de36f..61c679d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -451,6 +451,7 @@ static int irq_wait_for_interrupt(struct irqaction *action)
 	return -1;
 }
 
+#ifdef CONFIG_SMP
 /*
  * Check whether we need to change the affinity of the interrupt thread.
  */
@@ -478,6 +479,10 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
 	set_cpus_allowed_ptr(current, mask);
 	free_cpumask_var(mask);
 }
+#else
+static inline void
+irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action) { }
+#endif
 
 /*
  * Interrupt handler thread
