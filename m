Return-Path: <linux-kernel-owner+w=401wt.eu-S1423784AbXEAEJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423784AbXEAEJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946587AbXEAEAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:00:44 -0400
Received: from ns1.suse.de ([195.135.220.2]:60945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398AbXEAD6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:18 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [19/30] i386: Little cleanups in smpboot.c
Message-Id: <20070501035817.645CF13CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- Remove #if that is always set
- Fix warning

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/smpboot.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -516,7 +516,6 @@ static void unmap_cpu_to_logical_apicid(
 	unmap_cpu_to_node(cpu);
 }
 
-#if APIC_DEBUG
 static inline void __inquire_remote_apic(int apicid)
 {
 	int i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
@@ -548,14 +547,13 @@ static inline void __inquire_remote_apic
 		switch (status) {
 		case APIC_ICR_RR_VALID:
 			status = apic_read(APIC_RRR);
-			printk("%08x\n", status);
+			printk("%lx\n", status);
 			break;
 		default:
 			printk("failed\n");
 		}
 	}
 }
-#endif
 
 #ifdef WAKE_SECONDARY_VIA_NMI
 /* 
