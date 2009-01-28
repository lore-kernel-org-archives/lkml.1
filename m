Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbZA1Xx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbZA1Xx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758296AbZA1XoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:37509 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774AbZA1XoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:11 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 025/114] x86, apic: remove NUMAQ_IRQ_DELIVERY_MODE and NUMAQ_IRQ_DEST_MODE
Date: Wed, 28 Jan 2009 23:41:31 +0000
Message-Id: <1233186180-29883-26-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

They were only used in a single place and obscured the apic_numaq template.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/numaq/apic.h |    3 ---
 arch/x86/mach-generic/numaq.c     |    5 +++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 7746035..a9d8467 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -15,9 +15,6 @@ static inline const cpumask_t *target_cpus(void)
 #define NO_BALANCE_IRQ (1)
 #define esr_disable (1)
 
-#define NUMAQ_IRQ_DELIVERY_MODE dest_LowestPrio
-#define NUMAQ_IRQ_DEST_MODE 0     /* physical delivery on LOCAL quad */
- 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
 {
 	return physid_isset(apicid, bitmap);
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 77ac669..6daddb6 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -51,8 +51,9 @@ struct genapic apic_numaq = {
 	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= numaq_apic_id_registered,
 
-	.irq_delivery_mode		= NUMAQ_IRQ_DELIVERY_MODE,
-	.irq_dest_mode			= NUMAQ_IRQ_DEST_MODE,
+	.irq_delivery_mode		= dest_LowestPrio,
+	/* physical delivery on LOCAL quad: */
+	.irq_dest_mode			= 0,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
-- 
1.6.0.2

