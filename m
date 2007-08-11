Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbXHKAzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbXHKAzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 20:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765331AbXHKAzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 20:55:37 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44038 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443AbXHKAzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 20:55:36 -0400
Date: Fri, 10 Aug 2007 18:01:42 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: make io-apic not connected pin print complete
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200708101801.43121.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: make io-apic not connected pin print complete

normally will have two segment not connected pin
pin0, and pin after 15...

so need to print out "not connected\n" for previous segment,
before print out connected pins info...

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index 050141c..a591679 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -874,6 +874,10 @@ static void __init setup_IO_APIC_irqs(void)
 				apic_printk(APIC_VERBOSE, ", %d-%d", mp_ioapics[apic].mpc_apicid, pin);
 			continue;
 		}
+		if (!first_notcon) {
+			apic_printk(APIC_VERBOSE, " not connected.\n");
+			first_notcon = 1;
+		}
 
 		irq = pin_2_irq(idx, apic, pin);
 		add_pin_to_irq(irq, apic, pin);
@@ -884,7 +888,7 @@ static void __init setup_IO_APIC_irqs(void)
 	}
 
 	if (!first_notcon)
-		apic_printk(APIC_VERBOSE," not connected.\n");
+		apic_printk(APIC_VERBOSE, " not connected.\n");
 }
 
 /*
diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
index 893df82..39cf860 100644
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -1301,6 +1301,11 @@ static void __init setup_IO_APIC_irqs(void)
 			continue;
 		}
 
+		if (!first_notcon) {
+			apic_printk(APIC_VERBOSE, " not connected.\n");
+			first_notcon = 1;
+		}
+
 		entry.trigger = irq_trigger(idx);
 		entry.polarity = irq_polarity(idx);
 
