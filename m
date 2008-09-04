Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbYIDSow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbYIDSow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbYIDSjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:39:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:9991 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbYIDSjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=xDZmJ6SlgI387Zzi7HAG46+DPxLJJ+o1bd6JvPZJdjES6Nn60PugIi6Eo3dHqFADga
         b8RymVmWyidT9f/y1hyp0YUYi5SrOw/GC7OkXZtNbHlVj47xoXgEKnCCKfbj3aEZ41qw
         HB3iYDfuiPsGt6fjZOGWkvd3x+h421KzFYRzE=
References: <20080904183748.950151853@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 04 Sep 2008 22:37:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 3/3] x86: io-apic - code style cleaning for setup_IO_APIC_irqs
Content-Disposition: inline; filename=x86-ioapic-simplify-setup_IO_APIC_irqs
Message-ID: <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a nested level for 'for' cycle and break long lines.
For apic_print we should countinue using KERNEL_DEBUG if
we have started to.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic.c	2008-09-04 22:08:06.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic.c	2008-09-04 22:08:32.000000000 +0400
@@ -1521,32 +1521,35 @@ static void __init setup_IO_APIC_irqs(vo
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-	for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
 
-		idx = find_irq_entry(apic,pin,mp_INT);
-		if (idx == -1) {
-			if (first_notcon) {
-				apic_printk(APIC_VERBOSE, KERN_DEBUG " IO-APIC (apicid-pin) %d-%d", mp_ioapics[apic].mp_apicid, pin);
-				first_notcon = 0;
-			} else
-				apic_printk(APIC_VERBOSE, ", %d-%d", mp_ioapics[apic].mp_apicid, pin);
-			continue;
-		}
-		if (!first_notcon) {
-			apic_printk(APIC_VERBOSE, " not connected.\n");
-			first_notcon = 1;
-		}
+			idx = find_irq_entry(apic, pin, mp_INT);
+			if (idx == -1) {
+				if (first_notcon) {
+					apic_printk(APIC_VERBOSE, KERN_DEBUG
+							" IO-APIC (apicid-pin) %d-%d",
+							mp_ioapics[apic].mp_apicid, pin);
+					first_notcon = 0;
+				} else
+					apic_printk(APIC_VERBOSE, KERN_DEBUG ", %d-%d",
+							mp_ioapics[apic].mp_apicid, pin);
+				continue;
+			}
+			if (!first_notcon) {
+				apic_printk(APIC_VERBOSE, " not connected.\n");
+				first_notcon = 1;
+			}
 
-		irq = pin_2_irq(idx, apic, pin);
+			irq = pin_2_irq(idx, apic, pin);
 #ifdef CONFIG_X86_32
-                if (multi_timer_check(apic, irq))
-                        continue;
+			if (multi_timer_check(apic, irq))
+				continue;
 #endif
-		add_pin_to_irq(irq, apic, pin);
+			add_pin_to_irq(irq, apic, pin);
 
-		setup_IO_APIC_irq(apic, pin, irq,
-				  irq_trigger(idx), irq_polarity(idx));
-	}
+			setup_IO_APIC_irq(apic, pin, irq,
+					irq_trigger(idx), irq_polarity(idx));
+		}
 	}
 
 	if (!first_notcon)

-- 
