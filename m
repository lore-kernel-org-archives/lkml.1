Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbZA1Xwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbZA1Xwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbZA1XoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:37489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758250AbZA1XoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:05 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 024/114] x86, apic: remove SUMMIT_IRQ_DELIVERY_MODE and SUMMIT_IRQ_DEST_MODE
Date: Wed, 28 Jan 2009 23:41:30 +0000
Message-Id: <1233186180-29883-25-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

They were only used in a single place and obscured the apic_summit template.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/summit/apic.h |    3 ---
 arch/x86/mach-generic/summit.c     |    5 +++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index ea2abe9..427d088 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -24,9 +24,6 @@ static inline const cpumask_t *target_cpus(void)
 	return &cpumask_of_cpu(0);
 }
 
-#define SUMMIT_IRQ_DELIVERY_MODE (dest_LowestPrio)
-#define SUMMIT_IRQ_DEST_MODE 1     /* logical delivery broadcast to all procs */
-
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
 {
 	return 0;
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 7b3f43c..1b9164b 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -44,8 +44,9 @@ struct genapic apic_summit = {
 	.acpi_madt_oem_check		= summit_acpi_madt_oem_check,
 	.apic_id_registered		= summit_apic_id_registered,
 
-	.irq_delivery_mode		= SUMMIT_IRQ_DELIVERY_MODE,
-	.irq_dest_mode			= SUMMIT_IRQ_DEST_MODE,
+	.irq_delivery_mode		= dest_LowestPrio,
+	/* logical delivery broadcast to all CPUs: */
+	.irq_dest_mode			= 1,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
-- 
1.6.0.2

