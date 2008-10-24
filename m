Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYJXP6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYJXP6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 11:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYJXP6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 11:58:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:58664 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbYJXP6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 11:58:36 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, maxk@qualcomm.com,
       Andrew Morton <akpm@osdl.org>, tglx@linutronix.de
Subject: [PATCH] genirq: Set initial default irq affinity to just CPU0
Date: Fri, 24 Oct 2008 10:57:38 -0500
Message-Id: <1224863858-7933-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 18404756765c713a0be4eb1082920c04822ce588 introduced a regression
on a subset of SMP based PPC systems whose interrupt controller only
allow setting an irq to a single processor.  The previous behavior
was only CPU0 was initially setup to get interrupts.  Revert back
to that behavior.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c498a1b..728d36a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -17,7 +17,7 @@
 
 #ifdef CONFIG_SMP
 
-cpumask_t irq_default_affinity = CPU_MASK_ALL;
+cpumask_t irq_default_affinity = CPU_MASK_CPU0;
 
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
-- 
1.5.5.1

