Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbZA1Xyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbZA1Xyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbZA1XoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:37512 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279AbZA1XoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:12 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 026/114] x86, apic: remove BIGSMP_IRQ_DELIVERY_MODE and BIGSMP_IRQ_DEST_MODE
Date: Wed, 28 Jan 2009 23:41:32 +0000
Message-Id: <1233186180-29883-27-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

They were only used in a single place and obscured the apic_bigsmp
driver template.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h |    2 --
 arch/x86/mach-generic/bigsmp.c     |    5 +++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 293551b..dca2d5b 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -21,8 +21,6 @@ static inline const cpumask_t *target_cpus(void)
 #undef APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL	0
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
-#define BIGSMP_IRQ_DELIVERY_MODE (dest_Fixed)
-#define BIGSMP_IRQ_DEST_MODE	(0)    /* phys delivery to target proc */
 #define NO_BALANCE_IRQ		(0)
 
 static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index e8c1cec..06be776 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -64,8 +64,9 @@ struct genapic apic_bigsmp = {
 	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= bigsmp_apic_id_registered,
 
-	.irq_delivery_mode		= BIGSMP_IRQ_DELIVERY_MODE,
-	.irq_dest_mode			= BIGSMP_IRQ_DEST_MODE,
+	.irq_delivery_mode		= dest_Fixed,
+	/* phys delivery to target CPU: */
+	.irq_dest_mode			= 0,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
-- 
1.6.0.2

