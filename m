Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYGNRp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYGNRp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYGNRpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:45:20 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63695 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753803AbYGNRpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:45:19 -0400
Date: Mon, 14 Jul 2008 18:44:51 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: APIC: Make apic_verbosity unsigned
Message-ID: <Pine.LNX.4.55.0807141839210.17431@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 As a microoptimisation, make apic_verbosity unsigned.  This will make
apic_printk(APIC_QUIET, ...) expand into just printk(...) with the
surrounding condition and a reference to apic_verbosity removed.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-next-2.6.26-rc9-20080711-apic-verbosity-unsigned-2
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/apic_32.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/apic_32.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/apic_32.c	2008-07-11 15:56:32.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/apic_32.c	2008-07-14 17:02:46.000000000 +0000
@@ -75,7 +75,7 @@ char system_vectors[NR_VECTORS] = { [0 .
 /*
  * Debug level, exported for io_apic.c
  */
-int apic_verbosity;
+unsigned int apic_verbosity;
 
 int pic_mode;
 
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/apic_64.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/apic_64.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/apic_64.c	2008-07-09 18:01:12.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/apic_64.c	2008-07-14 17:02:56.000000000 +0000
@@ -54,7 +54,7 @@ EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok
 /*
  * Debug level, exported for io_apic.c
  */
-int apic_verbosity;
+unsigned int apic_verbosity;
 
 /* Have we found an MP table */
 int smp_found_config;
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/apic.h linux-next-2.6.26-rc9-20080711/include/asm-x86/apic.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/apic.h	2008-07-11 15:51:56.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/apic.h	2008-07-14 17:03:21.000000000 +0000
@@ -35,7 +35,7 @@ extern void generic_apic_probe(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
-extern int apic_verbosity;
+extern unsigned int apic_verbosity;
 extern int local_apic_timer_c2_ok;
 
 extern int ioapic_force;
