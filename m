Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbYIEOKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbYIEOKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYIEOKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:10:41 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34809 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753404AbYIEOKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:10:41 -0400
Date: Fri, 5 Sep 2008 09:10:40 -0500
From: Dean Nelson <dcn@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] set_irq_chip() has redundant call to irq_to_desc()
Message-ID: <20080905141040.GB9393@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extraneous call to irq_to_desc().

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 kernel/irq/chip.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/kernel/irq/chip.c
===================================================================
--- linux.orig/kernel/irq/chip.c	2008-09-05 08:04:21.000000000 -0500
+++ linux/kernel/irq/chip.c	2008-09-05 08:16:58.000000000 -0500
@@ -102,7 +102,6 @@ int set_irq_chip(unsigned int irq, struc
 	if (!chip)
 		chip = &no_irq_chip;
 
-	desc = irq_to_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	irq_chip_set_defaults(chip);
 	desc->chip = chip;
