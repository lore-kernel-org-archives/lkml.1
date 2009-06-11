Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbZFKWJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbZFKWJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762058AbZFKWIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:08:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:56702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762057AbZFKWIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:08:54 -0400
Message-ID: <4A318034.3010102@kernel.org>
Date: Thu, 11 Jun 2009 15:07:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use zalloc_cpumask_var in arch_early_irq_init
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So could make sure MAXSMP get clearred cpumask

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -187,8 +187,8 @@ int __init arch_early_irq_init(void)
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
-		alloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
-		alloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
+		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
+		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
 		if (i < NR_IRQS_LEGACY)
 			cpumask_setall(cfg[i].domain);
 	}
