Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbZFWHPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbZFWHPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758265AbZFWHOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:14:38 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:14135 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbZFWHOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:14:35 -0400
From: Len Brown <lenb@kernel.org>
To: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 8/8] SFI: expose IO-APIC routines to SFI, not just ACPI
Date: Tue, 23 Jun 2009 03:14:06 -0400
Message-id: <5ee3ec9f54201bf40549672017dc0a7880cb67b0.1245740912.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.3.3.334.g916e1
In-reply-to: <1245741246-6503-1-git-send-email-lenb@kernel.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
In-reply-to: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

change condition from
	#ifdef CONFIG_ACPI
to
	#if defined(CONFIG_ACPI) || defined(CONFIG_SFI)

for several io_apic related APIs which will be used by both
ACPI and SFI.

this change will ensure the success kernel build whe
CONFIG_SFI=y and CONFIG_ACPI=n

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/io_apic.h |    4 ++--
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 9d826e4..2e5ff36 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -150,13 +150,13 @@ extern int timer_through_8259;
 #define io_apic_assign_pci_irqs \
 	(mp_irq_entries && !skip_ioapic_setup && io_apic_irqs)
 
-#ifdef CONFIG_ACPI
+#if defined(CONFIG_ACPI) || defined(CONFIG_SFI)
 extern int io_apic_get_unique_id(int ioapic, int apic_id);
 extern int io_apic_get_version(int ioapic);
 extern int io_apic_get_redir_entries(int ioapic);
 extern int io_apic_set_pci_routing(int ioapic, int pin, int irq,
 				   int edge_level, int active_high_low);
-#endif /* CONFIG_ACPI */
+#endif /* CONFIG_ACPI || CONFIG_SFI */
 
 extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 30da617..2705476 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3904,7 +3904,7 @@ int __init arch_probe_nr_irqs(void)
                           ACPI-based IOAPIC Configuration
    -------------------------------------------------------------------------- */
 
-#ifdef CONFIG_ACPI
+#if defined(CONFIG_ACPI) || defined(CONFIG_SFI)
 
 #ifdef CONFIG_X86_32
 int __init io_apic_get_unique_id(int ioapic, int apic_id)
@@ -4045,7 +4045,7 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 	return 0;
 }
 
-#endif /* CONFIG_ACPI */
+#endif /* CONFIG_ACPI || CONFIG_SFI */
 
 /*
  * This function currently is only a helper for the i386 smp boot process where
-- 
1.6.0.6

