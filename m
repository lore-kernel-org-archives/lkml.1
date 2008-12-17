Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753282AbYLQVmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYLQVmm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYLQVmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:42:31 -0500
Received: from gw.goop.org ([64.81.55.164]:58062 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbYLQVma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:42:30 -0500
Message-ID: <49497245.7050409@goop.org>
Date: Wed, 17 Dec 2008 13:42:29 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: make sure irq_desc is allocated for interrupts
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bugfix

Make sure all Xen irqs have an irq_desc.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |    5 +++++
 1 file changed, 5 insertions(+)

===================================================================
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -233,6 +233,7 @@
 static int find_unbound_irq(void)
 {
 	int irq;
+	struct irq_desc *desc;
 
 	/* Only allocate from dynirq range */
 	for (irq = 0; irq < nr_irqs; irq++)
@@ -242,6 +243,10 @@
 	if (irq == nr_irqs)
 		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
+	desc = irq_to_desc_alloc_cpu(irq, 0);
+	if (WARN_ON(desc == NULL))
+		return -1;
+
 	return irq;
 }
 


