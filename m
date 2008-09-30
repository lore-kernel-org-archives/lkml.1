Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYI3XAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYI3XAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYI3XA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:00:28 -0400
Received: from ozlabs.org ([203.10.76.45]:50855 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbYI3XA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:00:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: remove noop cpus_and() with CPU_MASK_ALL.
Date: Wed, 1 Oct 2008 08:59:52 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810010859.52259.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure what this is supposed to do.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 52e0cb95ef98 arch/x86/kernel/io_apic_32.c
--- a/arch/x86/kernel/io_apic_32.c	Sat Sep 06 15:18:06 2008 +1000
+++ b/arch/x86/kernel/io_apic_32.c	Thu Sep 18 14:30:01 2008 +1000
@@ -346,9 +346,7 @@ static void set_ioapic_affinity_irq(unsi
 	if (cpus_empty(tmp))
 		tmp = TARGET_CPUS;
 
-	cpus_and(cpumask, tmp, CPU_MASK_ALL);
-
-	apicid_value = cpu_mask_to_apicid(cpumask);
+	apicid_value = cpu_mask_to_apicid(tmp);
 	/* Prepare to do the io_apic_write */
 	apicid_value = apicid_value << 24;
 	spin_lock_irqsave(&ioapic_lock, flags);
@@ -361,7 +359,7 @@ static void set_ioapic_affinity_irq(unsi
 			break;
 		entry = irq_2_pin + entry->next;
 	}
-	irq_desc[irq].affinity = cpumask;
+	irq_desc[irq].affinity = tmp;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
@@ -2613,12 +2611,10 @@ static void set_ht_irq_affinity(unsigned
 	if (cpus_empty(tmp))
 		tmp = TARGET_CPUS;
 
-	cpus_and(mask, tmp, CPU_MASK_ALL);
-
-	dest = cpu_mask_to_apicid(mask);
+	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest);
-	irq_desc[irq].affinity = mask;
+	irq_desc[irq].affinity = tmp;
 }
 #endif
 
