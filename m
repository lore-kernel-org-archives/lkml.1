Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbZKQWw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbZKQWw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbZKQWwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:52:06 -0500
Received: from www.tglx.de ([62.245.132.106]:41635 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756693AbZKQWwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:52:01 -0500
Message-Id: <20091117224916.856352649@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 17 Nov 2009 22:51:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [patch 13/13] genirq: Remove typename from struct irq_chip
References: <20091117224852.846805939@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-irqchip-typename.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last users of the migration helper are gone. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    6 ------
 kernel/irq/chip.c   |    2 --
 2 files changed, 8 deletions(-)

Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -106,7 +106,6 @@ struct msi_desc;
  * @bus_sync_unlock:	function to sync and unlock slow bus (i2c) chips
  *
  * @release:		release function solely used by UML
- * @typename:		obsoleted by name, kept as migration helper
  */
 struct irq_chip {
 	const char	*name;
@@ -135,11 +134,6 @@ struct irq_chip {
 #ifdef CONFIG_IRQ_RELEASE_METHOD
 	void		(*release)(unsigned int irq, void *dev_id);
 #endif
-	/*
-	 * For compatibility, ->typename is copied into ->name.
-	 * Will disappear.
-	 */
-	const char	*typename;
 };
 
 struct timer_rand_state;
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -310,8 +310,6 @@ void irq_chip_set_defaults(struct irq_ch
 	if (!chip->shutdown)
 		chip->shutdown = chip->disable != default_disable ?
 			chip->disable : default_shutdown;
-	if (!chip->name)
-		chip->name = chip->typename;
 	if (!chip->end)
 		chip->end = dummy_irq_chip.end;
 }


