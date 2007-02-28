Return-Path: <linux-kernel-owner+w=401wt.eu-S1751023AbXB1HmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbXB1HmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 02:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXB1HmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 02:42:24 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:44438 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbXB1HmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 02:42:23 -0500
Subject: [PATCH] affinity is not defined in non-smp kernels - i386 (v2)
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1172646816.29709.15.camel@sebastian.intellilink.co.jp>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <1172646816.29709.15.camel@sebastian.intellilink.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 28 Feb 2007 16:42:50 +0900
Message-Id: <1172648570.30062.2.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize affinity only when building SMP kernels.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

--- linux-2.6.21-rc2-dtt/arch/i386/kernel/io_apic.c	2007-03-06 15:20:14.000000000 +0900
+++ linux-2.6.21-rc2-kdump/arch/i386/kernel/io_apic.c	2007-03-06 15:51:45.000000000 +0900
@@ -1354,7 +1354,9 @@ static void __init setup_IO_APIC_irqs(vo
 		}
 		spin_lock_irqsave(&ioapic_lock, flags);
 		__ioapic_write_entry(apic, pin, entry);
+#ifdef CONFIG_SMP
 		irq_desc[irq].affinity = TARGET_CPUS;
+#endif
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 	}
@@ -2875,7 +2877,9 @@ int io_apic_set_pci_routing (int ioapic,
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__ioapic_write_entry(ioapic, pin, entry);
+#ifdef CONFIG_SMP
 	irq_desc[irq].affinity = TARGET_CPUS;
+#endif
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return 0;


