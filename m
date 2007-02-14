Return-Path: <linux-kernel-owner+w=401wt.eu-S932170AbXBNHnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbXBNHnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 02:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932171AbXBNHnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 02:43:11 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:50279
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932170AbXBNHnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 02:43:11 -0500
Message-Id: <45D2CB4A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Wed, 14 Feb 2007 07:41:46 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] small irq management simplification
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use mask_ack_irq() where possible.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- linux-2.6.20/kernel/irq/chip.c	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-irq-mask-ack/kernel/irq/chip.c	2007-02-09 10:17:26.000000000 +0100
@@ -534,10 +534,8 @@ __set_irq_handler(unsigned int irq, irq_
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
-		if (desc->chip != &no_irq_chip) {
-			desc->chip->mask(irq);
-			desc->chip->ack(irq);
-		}
+		if (desc->chip != &no_irq_chip)
+			mask_ack_irq(desc, irq);
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}


