Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbZA1Xrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbZA1Xrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757760AbZA1Xnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:43:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:37391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757598AbZA1Xnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:43:40 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 008/114] x86: clean up genapic_flat
Date: Wed, 28 Jan 2009 23:41:14 +0000
Message-Id: <1233186180-29883-9-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- reorder fields so that they appear in struct genapic field ordering

- add zero-initialized fields too so that it's apparent which functionality
  is default / missing.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/genapic_flat_64.c |   73 +++++++++++++++++++++++++++----------
 1 files changed, 54 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 3418548..f1bfdd3 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -175,25 +175,60 @@ static unsigned int phys_pkg_id(int index_msb)
 }
 
 struct genapic apic_flat =  {
-	.name = "flat",
-	.acpi_madt_oem_check = flat_acpi_madt_oem_check,
-	.int_delivery_mode = dest_LowestPrio,
-	.int_dest_mode = (APIC_DEST_LOGICAL != 0),
-	.target_cpus = flat_target_cpus,
-	.vector_allocation_domain = flat_vector_allocation_domain,
-	.apic_id_registered = flat_apic_id_registered,
-	.init_apic_ldr = flat_init_apic_ldr,
-	.send_IPI_all = flat_send_IPI_all,
-	.send_IPI_allbutself = flat_send_IPI_allbutself,
-	.send_IPI_mask = flat_send_IPI_mask,
-	.send_IPI_mask_allbutself = flat_send_IPI_mask_allbutself,
-	.send_IPI_self = apic_send_IPI_self,
-	.cpu_mask_to_apicid = flat_cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and = flat_cpu_mask_to_apicid_and,
-	.phys_pkg_id = phys_pkg_id,
-	.get_apic_id = get_apic_id,
-	.set_apic_id = set_apic_id,
-	.apic_id_mask = (0xFFu<<24),
+	.name				= "flat",
+	.probe				= NULL,
+	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
+	.apic_id_registered		= flat_apic_id_registered,
+
+	.int_delivery_mode		= dest_LowestPrio,
+	.int_dest_mode			= (APIC_DEST_LOGICAL != 0),
+
+	.target_cpus			= flat_target_cpus,
+	.ESR_DISABLE			= 0,
+	.apic_destination_logical	= 0,
+	.check_apicid_used		= NULL,
+	.check_apicid_present		= NULL,
+
+	.no_balance_irq			= 0,
+	.no_ioapic_check		= 0,
+
+	.vector_allocation_domain	= flat_vector_allocation_domain,
+	.init_apic_ldr			= flat_init_apic_ldr,
+
+	.ioapic_phys_id_map		= NULL,
+	.setup_apic_routing		= NULL,
+	.multi_timer_check		= NULL,
+	.apicid_to_node			= NULL,
+	.cpu_to_logical_apicid		= NULL,
+	.cpu_present_to_apicid		= NULL,
+	.apicid_to_cpu_present		= NULL,
+	.setup_portio_remap		= NULL,
+	.check_phys_apicid_present	= NULL,
+	.enable_apic_mode		= NULL,
+	.phys_pkg_id			= phys_pkg_id,
+	.mps_oem_check			= NULL,
+
+	.get_apic_id			= get_apic_id,
+	.set_apic_id			= set_apic_id,
+	.apic_id_mask			= 0xFFu << 24,
+
+	.cpu_mask_to_apicid		= flat_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= flat_cpu_mask_to_apicid_and,
+
+	.send_IPI_mask			= flat_send_IPI_mask,
+	.send_IPI_mask_allbutself	= flat_send_IPI_mask_allbutself,
+	.send_IPI_allbutself		= flat_send_IPI_allbutself,
+	.send_IPI_all			= flat_send_IPI_all,
+	.send_IPI_self			= apic_send_IPI_self,
+
+	.wakeup_cpu			= NULL,
+	.trampoline_phys_low		= 0,
+	.trampoline_phys_high		= 0,
+	.wait_for_init_deassert		= NULL,
+	.smp_callin_clear_local_apic	= NULL,
+	.store_NMI_vector		= NULL,
+	.restore_NMI_vector		= NULL,
+	.inquire_remote_apic		= NULL,
 };
 
 /*
-- 
1.6.0.2

