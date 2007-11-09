Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbXKISfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbXKISfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbXKISfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:35:08 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:32526 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbXKISfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:35:07 -0500
Message-ID: <4734A844.6010601@ct.jp.nec.com>
Date: Fri, 09 Nov 2007 10:34:44 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: io_apic_64.c: remove unused config check
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_IRQBALANCE doesn't exist on x86_64.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/io_apic_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 953328b..04b90ce 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1435,7 +1435,7 @@ static void ack_apic_level(unsigned int irq)
 	int do_unmask_irq = 0;
 
 	irq_complete_move(irq);
-#if defined(CONFIG_GENERIC_PENDING_IRQ) || defined(CONFIG_IRQBALANCE)
+#ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
-- 
1.5.3.4
