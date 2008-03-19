Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbYCSToZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbYCSToZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbYCSTbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:31:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275AbYCSTax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:53 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 02/79] [PATCH] add loglevel to printks
Date: Wed, 19 Mar 2008 14:24:57 -0300
Message-Id: <12059475853453-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947580526-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add loglevel facilities to printks in __inquire_remote_apic.
the levels are the ones to match x86_64 ones.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index bea2d32..8676eec 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -373,17 +373,18 @@ static inline void __inquire_remote_apic(int apicid)
 	int timeout;
 	u32 status;
 
-	printk("Inquiring remote APIC #%d...\n", apicid);
+	printk(KERN_INFO "Inquiring remote APIC #%d...\n", apicid);
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++) {
-		printk("... APIC #%d %s: ", apicid, names[i]);
+		printk(KERN_INFO "... APIC #%d %s: ", apicid, names[i]);
 
 		/*
 		 * Wait for idle.
 		 */
 		status = safe_apic_wait_icr_idle();
 		if (status)
-			printk("a previous APIC delivery may have failed\n");
+			printk(KERN_CONT
+			       "a previous APIC delivery may have failed\n");
 
 		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
 		apic_write_around(APIC_ICR, APIC_DM_REMRD | regs[i]);
@@ -397,10 +398,10 @@ static inline void __inquire_remote_apic(int apicid)
 		switch (status) {
 		case APIC_ICR_RR_VALID:
 			status = apic_read(APIC_RRR);
-			printk("%lx\n", status);
+			printk(KERN_CONT "%08x\n", status);
 			break;
 		default:
-			printk("failed\n");
+			printk(KERN_CONT "failed\n");
 		}
 	}
 }
-- 
1.5.0.6

