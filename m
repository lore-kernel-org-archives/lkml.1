Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbZA1Xug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbZA1Xug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbZA1Xny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:43:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:37440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbZA1Xnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:43:53 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 016/114] x86, genapic: cleanup 32-bit apic_es7000 template
Date: Wed, 28 Jan 2009 23:41:22 +0000
Message-Id: <1233186180-29883-17-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the APIC driver template:

 - order fields properly
 - use the macro names explicitly (so that they can be renamed later)
 - fill in NULL entries as well

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mach-generic/es7000.c |   58 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 2f4f4a6..4a404ea 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -100,4 +100,60 @@ static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 
-struct genapic __initdata_refok apic_es7000 = APIC_INIT("es7000", probe_es7000);
+struct genapic apic_es7000 = {
+
+	.name				= "es7000",
+	.probe				= probe_es7000,
+	.acpi_madt_oem_check		= acpi_madt_oem_check,
+	.apic_id_registered		= apic_id_registered,
+
+	.int_delivery_mode		= INT_DELIVERY_MODE,
+	.int_dest_mode			= INT_DEST_MODE,
+
+	.target_cpus			= target_cpus,
+	.ESR_DISABLE			= esr_disable,
+	.apic_destination_logical	= APIC_DEST_LOGICAL,
+	.check_apicid_used		= check_apicid_used,
+	.check_apicid_present		= check_apicid_present,
+
+	.no_balance_irq			= NO_BALANCE_IRQ,
+	.no_ioapic_check		= 0,
+
+	.vector_allocation_domain	= vector_allocation_domain,
+	.init_apic_ldr			= init_apic_ldr,
+
+	.ioapic_phys_id_map		= ioapic_phys_id_map,
+	.setup_apic_routing		= setup_apic_routing,
+	.multi_timer_check		= multi_timer_check,
+	.apicid_to_node			= apicid_to_node,
+	.cpu_to_logical_apicid		= cpu_to_logical_apicid,
+	.cpu_present_to_apicid		= cpu_present_to_apicid,
+	.apicid_to_cpu_present		= apicid_to_cpu_present,
+	.setup_portio_remap		= setup_portio_remap,
+	.check_phys_apicid_present	= check_phys_apicid_present,
+	.enable_apic_mode		= enable_apic_mode,
+	.phys_pkg_id			= phys_pkg_id,
+	.mps_oem_check			= mps_oem_check,
+
+	.get_apic_id			= get_apic_id,
+	.set_apic_id			= NULL,
+	.apic_id_mask			= APIC_ID_MASK,
+
+	.cpu_mask_to_apicid		= cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= cpu_mask_to_apicid_and,
+
+	.send_IPI_mask			= send_IPI_mask,
+	.send_IPI_mask_allbutself	= NULL,
+	.send_IPI_allbutself		= send_IPI_allbutself,
+	.send_IPI_all			= send_IPI_all,
+	.send_IPI_self			= NULL,
+
+	.wakeup_cpu			= NULL,
+	.trampoline_phys_low		= TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= TRAMPOLINE_PHYS_HIGH,
+	.wait_for_init_deassert		= wait_for_init_deassert,
+	.smp_callin_clear_local_apic	= smp_callin_clear_local_apic,
+	.store_NMI_vector		= store_NMI_vector,
+	.restore_NMI_vector		= restore_NMI_vector,
+	.inquire_remote_apic		= inquire_remote_apic,
+};
-- 
1.6.0.2

