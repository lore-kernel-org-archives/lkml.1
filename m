Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbYE0UU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbYE0UU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758381AbYE0UT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:19:56 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63936 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759430AbYE0UTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:19:55 -0400
Date: Tue, 27 May 2008 21:19:28 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] x86: I/O APIC: Remove redundant LVT0 masking
Message-ID: <Pine.LNX.4.55.0805271928050.18833@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The LINT0 line of the local APIC is masked in the LVT0 entry in 
check_timer() before this function is ever called.  Removed the redundant 
unmasking for better control.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-timer-extint-nolvt0-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-25 02:03:08.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-25 16:56:01.000000000 +0000
@@ -1310,9 +1310,6 @@ static void __init setup_ExtINT_IRQ0_pin
 
 	memset(&entry,0,sizeof(entry));
 
-	/* mask LVT0 */
-	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
-
 	/*
 	 * We use logical delivery to get the timer IRQ
 	 * to the first CPU.
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-05-25 16:56:37.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-05-25 17:00:25.000000000 +0000
@@ -920,9 +920,6 @@ static void __init setup_ExtINT_IRQ0_pin
 
 	memset(&entry, 0, sizeof(entry));
 
-	/* mask LVT0 */
-	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
-
 	/*
 	 * We use logical delivery to get the timer IRQ
 	 * to the first CPU.
