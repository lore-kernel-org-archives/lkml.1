Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbYGHRD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbYGHRD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbYGHQ6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:58:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:38007 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707AbYGHQ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:58:24 -0400
Date: Tue, 8 Jul 2008 09:42:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 4/17] Use WARN() in kernel/irq/manage.c
Message-ID: <20080708094208.173edad6@infradead.org>
In-Reply-To: <20080708093800.274504ba@infradead.org>
References: <20080708093800.274504ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

Replace a printk+WARN_ON() by a WARN(); this increases the chance of the
string making it into the bugreport (ie: it goes inside the
---[ cut here ]--- section)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux.trees.git/kernel/irq/manage.c
===================================================================
--- linux.trees.git.orig/kernel/irq/manage.c
+++ linux.trees.git/kernel/irq/manage.c
@@ -177,8 +177,7 @@ static void __enable_irq(struct irq_desc
 {
 	switch (desc->depth) {
 	case 0:
-		printk(KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
-		WARN_ON(1);
+		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
 		break;
 	case 1: {
 		unsigned int status = desc->status & ~IRQ_DISABLED;
@@ -247,9 +246,7 @@ int set_irq_wake(unsigned int irq, unsig
 			set_wake = NULL;
 	} else {
 		if (desc->wake_depth == 0) {
-			printk(KERN_WARNING "Unbalanced IRQ %d "
-					"wake disable\n", irq);
-			WARN_ON(1);
+			WARN(1, "Unbalanced IRQ %d wake disable\n", irq);
 		} else if (--desc->wake_depth == 0)
 			desc->status &= ~IRQ_WAKEUP;
 		else
