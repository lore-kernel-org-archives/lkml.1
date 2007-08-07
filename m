Return-Path: <linux-kernel-owner+w=401wt.eu-S934960AbXHGUOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934960AbXHGUOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757682AbXHGUN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:13:58 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45184 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbXHGUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:13:56 -0400
Date: Tue, 07 Aug 2007 13:19:23 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: remove sync_Arb_IDs
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200708071319.23586.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: remove sync_Arb_IDs

i386 code said
       /*
        * Unsupported on P4 - see Intel Dev. Manual Vol. 3, Ch. 8.6.1 And not
        * needed on AMD.
        */
So we don't need sync_Arb_IDs for x86_64...

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 900ff38..800dec3 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
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
diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index 050141c..171359c 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -1783,7 +1786,6 @@ void __init setup_IO_APIC(void)
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
 
-	sync_Arb_IDs();
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
 	check_timer();
