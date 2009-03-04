Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZCDOAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZCDOAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZCDN74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:59:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37909 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZCDN74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:59:56 -0500
Subject: [PATCH] lockdep: remove extra "irq" string
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 14:59:52 +0100
Message-Id: <1236175192.5330.7585.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: lockdep: remove extra "irq" string
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Mar 04 14:53:24 CET 2009

print_irq_inversion_bug() gets handed state strings of the form

  "HARDIRQ", "SOFTIRQ", "RECLAIM_FS"

and appends "-irq-{un,}safe" to them, which is either redudant for *IRQ or
confusing in the RECLAIM_FS case.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -1901,9 +1901,9 @@ print_irq_inversion_bug(struct task_stru
 		curr->comm, task_pid_nr(curr));
 	print_lock(this);
 	if (forwards)
-		printk("but this lock took another, %s-irq-unsafe lock in the past:\n", irqclass);
+		printk("but this lock took another, %s-unsafe lock in the past:\n", irqclass);
 	else
-		printk("but this lock was taken by another, %s-irq-safe lock in the past:\n", irqclass);
+		printk("but this lock was taken by another, %s-safe lock in the past:\n", irqclass);
 	print_lock_name(other);
 	printk("\n\nand interrupts could create inverse lock ordering between them.\n\n");
 


