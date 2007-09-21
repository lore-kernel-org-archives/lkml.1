Return-Path: <linux-kernel-owner+w=401wt.eu-S1763696AbXIUWd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763696AbXIUWd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762305AbXIUWcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:40442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761912AbXIUWcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:02 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: yhlu.kernel@gmail.com, clameter@sgi.com, ak@suse.de, lenb@kernel.org,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/50] x86_64: remove never used apic_mapped
Message-Id: <20070921223201.1F5AA13DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Yinghai Lu" <yhlu.kernel@gmail.com>

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c |    5 ++---
 include/asm-x86_64/apic.h |    1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: linux/arch/x86_64/kernel/apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/apic.c
+++ linux/arch/x86_64/kernel/apic.c
@@ -39,7 +39,6 @@
 #include <asm/hpet.h>
 #include <asm/apic.h>
 
-int apic_mapped;
 int apic_verbosity;
 int apic_runs_main_timer;
 int apic_calibrate_pmtmr __initdata;
@@ -697,8 +696,8 @@ void __init init_apic_mappings(void)
 		apic_phys = mp_lapic_addr;
 
 	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-	apic_mapped = 1;
-	apic_printk(APIC_VERBOSE,"mapped APIC to %16lx (%16lx)\n", APIC_BASE, apic_phys);
+	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+				APIC_BASE, apic_phys);
 
 	/* Put local APIC into the resource map. */
 	lapic_resource.start = apic_phys;
Index: linux/include/asm-x86_64/apic.h
===================================================================
--- linux.orig/include/asm-x86_64/apic.h
+++ linux/include/asm-x86_64/apic.h
@@ -19,7 +19,6 @@
 extern int apic_verbosity;
 extern int apic_runs_main_timer;
 extern int ioapic_force;
-extern int apic_mapped;
 
 /*
  * Define the default level of output to be very little
