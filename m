Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbZA1Xvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbZA1Xvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbZA1XoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:37464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017AbZA1XoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:00 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 018/114] x86: remove APIC_INIT / APICFUNC / IPIFUNC
Date: Wed, 28 Jan 2009 23:41:24 +0000
Message-Id: <1233186180-29883-19-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The APIC_INIT() / APICFUNC / IPIFUNC macros were ugly and obfuscated
the true identity of various APIC driver methods.

Now that they are not used anymore, remove them.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic.h |   63 +--------------------------------------
 1 files changed, 2 insertions(+), 61 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 3970da3..26c5e82 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -97,66 +97,8 @@ struct genapic {
 extern struct genapic *apic;
 
 #ifdef CONFIG_X86_32
-
-#define APICFUNC(x) .x = x,
-
-/* More functions could be probably marked IPIFUNC and save some space
-   in UP GENERICARCH kernels, but I don't have the nerve right now
-   to untangle this mess. -AK  */
-#ifdef CONFIG_SMP
-#define IPIFUNC(x) APICFUNC(x)
-#else
-#define IPIFUNC(x)
-#endif
-
-#define APIC_INIT(aname, aprobe)			\
-{							\
-	.name = aname,					\
-	.probe = aprobe,				\
-	.int_delivery_mode = INT_DELIVERY_MODE,		\
-	.int_dest_mode = INT_DEST_MODE,			\
-	.no_balance_irq = NO_BALANCE_IRQ,		\
-	.ESR_DISABLE = esr_disable,			\
-	.apic_destination_logical = APIC_DEST_LOGICAL,	\
-	APICFUNC(apic_id_registered)			\
-	APICFUNC(target_cpus)				\
-	APICFUNC(check_apicid_used)			\
-	APICFUNC(check_apicid_present)			\
-	APICFUNC(init_apic_ldr)				\
-	APICFUNC(ioapic_phys_id_map)			\
-	APICFUNC(setup_apic_routing)			\
-	APICFUNC(multi_timer_check)			\
-	APICFUNC(apicid_to_node)			\
-	APICFUNC(cpu_to_logical_apicid)			\
-	APICFUNC(cpu_present_to_apicid)			\
-	APICFUNC(apicid_to_cpu_present)			\
-	APICFUNC(setup_portio_remap)			\
-	APICFUNC(check_phys_apicid_present)		\
-	APICFUNC(mps_oem_check)				\
-	APICFUNC(get_apic_id)				\
-	.apic_id_mask = APIC_ID_MASK,			\
-	APICFUNC(cpu_mask_to_apicid)			\
-	APICFUNC(cpu_mask_to_apicid_and)		\
-	APICFUNC(vector_allocation_domain)		\
-	APICFUNC(acpi_madt_oem_check)			\
-	IPIFUNC(send_IPI_mask)				\
-	IPIFUNC(send_IPI_allbutself)			\
-	IPIFUNC(send_IPI_all)				\
-	APICFUNC(enable_apic_mode)			\
-	APICFUNC(phys_pkg_id)				\
-	.trampoline_phys_low = TRAMPOLINE_PHYS_LOW,	\
-	.trampoline_phys_high = TRAMPOLINE_PHYS_HIGH,	\
-	APICFUNC(wait_for_init_deassert)		\
-	APICFUNC(smp_callin_clear_local_apic)		\
-	APICFUNC(store_NMI_vector)			\
-	APICFUNC(restore_NMI_vector)			\
-	APICFUNC(inquire_remote_apic)			\
-}
-
 extern void es7000_update_genapic_to_cluster(void);
-
-#else /* CONFIG_X86_64: */
-
+#else
 extern struct genapic apic_flat;
 extern struct genapic apic_physflat;
 extern struct genapic apic_x2apic_cluster;
@@ -169,7 +111,6 @@ extern struct genapic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
 
 extern void setup_apic_routing(void);
-
-#endif /* CONFIG_X86_64 */
+#endif
 
 #endif /* _ASM_X86_GENAPIC_64_H */
-- 
1.6.0.2

