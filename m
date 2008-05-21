Return-Path: <linux-kernel-owner+w=401wt.eu-S937534AbYEUVMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937534AbYEUVMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937367AbYEUVJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:09:57 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63927 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937349AbYEUVJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:09:56 -0400
Date: Wed, 21 May 2008 22:09:34 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] x86: I/O APIC: Keep IRQ off when changing LVT registers
Message-ID: <Pine.LNX.4.55.0805212035050.4894@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Disable the 8259A acting in the "virtual wire" mode to keep the interrupt
line inactive while fiddling with local APIC interrupt vector registers
associated with its destination inputs.  To be on the safe side, 
especially concerning flipping the trigger mode.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-timer-8259-nmi-unmask-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-21 18:52:36.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-21 18:52:36.000000000 +0000
@@ -2199,7 +2199,9 @@ static inline void __init check_timer(vo
 			else
 				add_pin_to_irq(0, apic2, pin2);
 			if (nmi_watchdog == NMI_IO_APIC) {
+				disable_8259A_irq(0);
 				setup_nmi();
+				enable_8259A_irq(0);
 			}
 			goto out;
 		}
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-05-21 19:00:05.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-05-18 00:24:43.000000000 +0000
@@ -1702,7 +1702,9 @@ static inline void __init check_timer(vo
 			apic_printk(APIC_VERBOSE," works.\n");
 			nmi_watchdog_default();
 			if (nmi_watchdog == NMI_IO_APIC) {
+				disable_8259A_irq(0);
 				setup_nmi();
+				enable_8259A_irq(0);
 			}
 			goto out;
 		}
