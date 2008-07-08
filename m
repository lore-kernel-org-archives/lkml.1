Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYGHQ7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYGHQ7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbYGHQ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:57:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:55118 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350AbYGHQ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:57:36 -0400
Date: Tue, 8 Jul 2008 09:48:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 8/17] use WARN() in kernel/irq/chip.c
Message-ID: <20080708094805.2d1696a4@infradead.org>
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
Subject: Use WARN instead of printk+WARN_ON in kernel/irq

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/irq/chip.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

Index: linux.trees.git/kernel/irq/chip.c
===================================================================
--- linux.trees.git.orig/kernel/irq/chip.c
+++ linux.trees.git/kernel/irq/chip.c
@@ -28,8 +28,7 @@ void dynamic_irq_init(unsigned int irq)
 	unsigned long flags;
 
 	if (irq >= NR_IRQS) {
-		printk(KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
 		return;
 	}
 
@@ -62,8 +61,7 @@ void dynamic_irq_cleanup(unsigned int ir
 	unsigned long flags;
 
 	if (irq >= NR_IRQS) {
-		printk(KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
 		return;
 	}
 
@@ -71,9 +69,8 @@ void dynamic_irq_cleanup(unsigned int ir
 	spin_lock_irqsave(&desc->lock, flags);
 	if (desc->action) {
 		spin_unlock_irqrestore(&desc->lock, flags);
-		printk(KERN_ERR "Destroying IRQ%d without calling free_irq\n",
+		WARN(1, KERN_ERR "Destroying IRQ%d without calling free_irq\n",
 			irq);
-		WARN_ON(1);
 		return;
 	}
 	desc->msi_desc = NULL;
@@ -96,8 +93,7 @@ int set_irq_chip(unsigned int irq, struc
 	unsigned long flags;
 
 	if (irq >= NR_IRQS) {
-		printk(KERN_ERR "Trying to install chip for IRQ%d\n", irq);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
 		return -EINVAL;
 	}
 
