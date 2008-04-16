Return-Path: <linux-kernel-owner+w=401wt.eu-S1764597AbYDPURb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764597AbYDPURb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYDPURV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:17:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35961 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752008AbYDPURU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:17:20 -0400
Date: Wed, 16 Apr 2008 15:17:20 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: Alan Mayer <ajm@sgi.com>
Cc: mingo@elte.hu, torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
In-Reply-To: <Pine.SGI.3.96.1080415153530.8706317k-100000@fergus.americas.sgi.com>
Message-ID: <Pine.SGI.3.96.1080416151620.8706317m-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] x86_64: Fix build error from FIRST_SYSTEM_VECTOR patch

From: Alan Mayer <ajm@sgi.com>

Fixes the build error introduced by my FIRST_SYSTEM_VECTOR patch

Signed-off-by: Alan Mayer <ajm@sgi.com>

---
Index: ingo/arch/x86/kernel/apic_32.c
===================================================================
--- ingo.orig/arch/x86/kernel/apic_32.c	2008-04-10 14:02:10.000000000 -0500
+++ ingo/arch/x86/kernel/apic_32.c	2008-04-16 14:28:34.000000000 -0500
@@ -74,6 +74,10 @@
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
 
+int first_system_vector = 0xfe;
+
+char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
+
 /*
  * Debug level, exported for io_apic.c
  */
Index: ingo/arch/x86/kernel/io_apic_32.c
===================================================================
--- ingo.orig/arch/x86/kernel/io_apic_32.c	2008-04-10 14:02:10.000000000 -0500
+++ ingo/arch/x86/kernel/io_apic_32.c	2008-04-16 14:29:07.000000000 -0500
@@ -73,9 +73,9 @@
 
 static int disable_timer_pin_1 __initdata;
 
-int first_system_vector = 0xfe;
+extern int first_system_vector;
 
-char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
+extern char system_vectors[];
 
 /*
  * Rough estimation of how many shared IRQs there are, can

