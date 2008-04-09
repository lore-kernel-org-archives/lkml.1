Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbYDIWE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbYDIWE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 18:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYDIWES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 18:04:18 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49417 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752465AbYDIWER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:04:17 -0400
Date: Wed, 9 Apr 2008 16:35:04 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_64: Add XPC interrupt vectors for SGIs UV system.
Message-ID: <Pine.SGI.3.96.1080409163354.8706317M-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] x86_64: Add XPC interrupt vectors for SGIs UV system.

From: Alan Mayer <ajm@sgi.com>

The UV system needs two high priority interrupts for the XPC
subsystem.  This adds them below the common system interrupt vectors.

Signed-off-by: Alan Mayer <ajm@sgi.com>

---

Index: ingo/arch/x86/kernel/i8259_64.c
===================================================================
--- ingo.orig/arch/x86/kernel/i8259_64.c	2008-04-09 10:08:11.000000000 -0500
+++ ingo/arch/x86/kernel/i8259_64.c	2008-04-09 15:57:08.000000000 -0500
@@ -524,6 +524,11 @@
 	set_intr_gate(alloc_system_vector(SPURIOUS_APIC_VECTOR), spurious_interrupt);
 	set_intr_gate(alloc_system_vector(ERROR_APIC_VECTOR), error_interrupt);
 
+	if (is_uv_system() ) {
+		alloc_system_vector(XPC_ACTIVATE);
+		alloc_system_vector(XPC_NOTIFY);
+	}
+
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 }
Index: ingo/include/asm-x86/hw_irq_64.h
===================================================================
--- ingo.orig/include/asm-x86/hw_irq_64.h	2008-04-09 10:08:53.000000000 -0500
+++ ingo/include/asm-x86/hw_irq_64.h	2008-04-09 15:55:47.000000000 -0500
@@ -85,6 +85,10 @@
  */
 #define LOCAL_TIMER_VECTOR	0xef
 
+#define XPC_ACTIVATE		0xee
+#define XPC_NOTIFY		0xed
+
+
 /*
  * First APIC vector available to drivers: (vectors 0x30-0xee)
  * we start at 0x41 to spread out vectors evenly between priority

