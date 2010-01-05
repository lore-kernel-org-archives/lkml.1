Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432Ab0AETir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0AETir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417Ab0AETiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:38:46 -0500
Received: from bamako.nerim.net ([62.4.17.28]:57010 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab0AETip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:38:45 -0500
Date: Tue, 5 Jan 2010 20:38:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] set_irq_noprobe shouldn't be __init
Message-ID: <20100105203842.04a1a523@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non-__init functions need to call set_irq_noprobe() so this function
shouldn't be marked __init. Also remove __init from set_irq_probe()
for consistency.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 kernel/irq/chip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.33-rc2.orig/kernel/irq/chip.c	2009-12-18 08:34:52.000000000 +0100
+++ linux-2.6.33-rc2/kernel/irq/chip.c	2010-01-05 17:21:38.000000000 +0100
@@ -682,7 +682,7 @@ set_irq_chip_and_handler_name(unsigned i
 	__set_irq_handler(irq, handle, 0, name);
 }
 
-void __init set_irq_noprobe(unsigned int irq)
+void set_irq_noprobe(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -697,7 +697,7 @@ void __init set_irq_noprobe(unsigned int
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
-void __init set_irq_probe(unsigned int irq)
+void set_irq_probe(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;


-- 
Jean Delvare
