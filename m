Return-Path: <linux-kernel-owner+w=401wt.eu-S1759833AbZA1XzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833AbZA1XzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758307AbZA1XoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:37525 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZA1XoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:16 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 027/114] x86, apic: remove ES7000_IRQ_DELIVERY_MODE and ES7000_IRQ_DEST_MODE
Date: Wed, 28 Jan 2009 23:41:33 +0000
Message-Id: <1233186180-29883-28-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

They were only used in a single place and obscured the apic_es7000
driver template.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/es7000/apic.h |    2 --
 arch/x86/mach-generic/es7000.c     |    5 +++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 6900166..342416b 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -27,8 +27,6 @@ static inline const cpumask_t *target_cpus(void)
 #define NO_BALANCE_IRQ_CLUSTER		(1)
 
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
-#define ES7000_IRQ_DELIVERY_MODE (dest_Fixed)
-#define ES7000_IRQ_DEST_MODE	(0)    /* phys delivery to target procs */
 #define NO_BALANCE_IRQ		(0)
 #undef  APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL	0x0
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 5d97408..269a97a 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -107,8 +107,9 @@ struct genapic apic_es7000 = {
 	.acpi_madt_oem_check		= es7000_acpi_madt_oem_check,
 	.apic_id_registered		= es7000_apic_id_registered,
 
-	.irq_delivery_mode		= ES7000_IRQ_DELIVERY_MODE,
-	.irq_dest_mode			= ES7000_IRQ_DEST_MODE,
+	.irq_delivery_mode		= dest_Fixed,
+	/* phys delivery to target CPUs: */
+	.irq_dest_mode			= 0,
 
 	.target_cpus			= target_cpus,
 	.ESR_DISABLE			= esr_disable,
-- 
1.6.0.2

