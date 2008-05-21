Return-Path: <linux-kernel-owner+w=401wt.eu-S937097AbYEUVL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937097AbYEUVL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937302AbYEUVJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:09:49 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63922 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937299AbYEUVJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:09:48 -0400
Date: Wed, 21 May 2008 22:09:26 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] x86: I/O APIC: Clean up after a fasteoi failure
Message-ID: <Pine.LNX.4.55.0805212034430.4894@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Disable the 8259A when routing of the timer interrupt through the chip to 
the local APIC of the primary processor has failed.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-timer-fasteoi-cleanup-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-21 18:51:28.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-21 18:52:36.000000000 +0000
@@ -2228,6 +2228,7 @@ static inline void __init check_timer(vo
 		printk(" works.\n");
 		goto out;
 	}
+	disable_8259A_irq(0);
 	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | vector);
 	printk(" failed.\n");
 
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-05-18 00:24:43.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-05-21 19:00:05.000000000 +0000
@@ -1729,6 +1729,7 @@ static inline void __init check_timer(vo
 		apic_printk(APIC_VERBOSE," works.\n");
 		goto out;
 	}
+	disable_8259A_irq(0);
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
 	apic_printk(APIC_VERBOSE," failed.\n");
 
