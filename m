Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYLAEp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYLAEp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 23:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYLAEpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 23:45:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:42086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbYLAEpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 23:45:14 -0500
Message-ID: <49336BB8.4020303@kernel.org>
Date: Sun, 30 Nov 2008 20:44:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] irq: sparse irq_desc[] support - fix
References: <492A1877.4090304@kernel.org> <20081124144007.GA30725@elte.hu> <492B77C5.2050502@kernel.org> <20081126074826.GI26036@elte.hu> <492D02A4.4030206@kernel.org> <20081126081724.GK26036@elte.hu> <492E0540.9010009@kernel.org> <20081128163456.GB10487@elte.hu> <4930EB7F.1080307@kernel.org> <20081129100253.GD26691@elte.hu> <20081129102619.GA3901@elte.hu>
In-Reply-To: <20081129102619.GA3901@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix warning

remove unneeded warning

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 2861122..8aa0954 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -158,13 +158,7 @@ void __init early_irq_init(void)
 
 struct irq_desc *irq_to_desc(unsigned int irq)
 {
-	if (irq >= NR_IRQS) {
-		printk(KERN_WARNING "irq >= NR_IRQS in irq_to_desc: %d %d\n",
-				irq, NR_IRQS);
-		WARN_ON(1);
-		return NULL;
-	}
-	return irq_desc_ptrs[irq];
+	return (irq < NR_IRQS) ? irq_desc_ptrs[irq] : NULL;
 }
 
 struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
