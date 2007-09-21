Return-Path: <linux-kernel-owner+w=401wt.eu-S1764643AbXIUUxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764643AbXIUUxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763379AbXIUUpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:17 -0400
Received: from mx1.suse.de ([195.135.220.2]:50057 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761658AbXIUUpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:08 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: Yinghai.Lu@Sun.COM, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [25/45] x86_64: remove sync_Arb_IDs
Message-Id: <20070921204507.71C1A14EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Yinghai Lu <Yinghai.Lu@Sun.COM>
[PATCH] x86_64: remove sync_Arb_IDs

i386 code said
       /*
        * Unsupported on P4 - see Intel Dev. Manual Vol. 3, Ch. 8.6.1 And not
        * needed on AMD.
        */
So we don't need sync_Arb_IDs for x86_64...

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/apic.c    |   17 -----------------
 arch/x86_64/kernel/io_apic.c |    1 -
 2 files changed, 18 deletions(-)

Index: linux/arch/x86_64/kernel/apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/apic.c
+++ linux/arch/x86_64/kernel/apic.c
@@ -283,23 +283,6 @@ int __init verify_local_APIC(void)
 	return 1;
 }
 
-void __init sync_Arb_IDs(void)
-{
-	/* Unsupported on P4 - see Intel Dev. Manual Vol. 3, Ch. 8.6.1 */
-	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
-	if (ver >= 0x14)	/* P4 or higher */
-		return;
-
-	/*
-	 * Wait for idle.
-	 */
-	apic_wait_icr_idle();
-
-	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
-	apic_write(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG
-				| APIC_DM_INIT);
-}
-
 /*
  * An initial setup of the virtual wire mode.
  */
Index: linux/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/io_apic.c
+++ linux/arch/x86_64/kernel/io_apic.c
@@ -1784,7 +1784,6 @@ void __init setup_IO_APIC(void)
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
 
-	sync_Arb_IDs();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
 	check_timer();
