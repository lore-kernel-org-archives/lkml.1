Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbYJONhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbYJONhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 09:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYJONgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 09:36:51 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:59836 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbYJONgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 09:36:50 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: remove redundant KERN_DEBUG on pr_debug
Date: Wed, 15 Oct 2008 10:37:04 -0300
Message-Id: <1224077824-28102-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_debug don't need KERN_DEBUG.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/acpi/boot.c    |    2 +-
 arch/x86/kernel/setup_percpu.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index eb875cd..1852f3e 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1136,7 +1136,7 @@ int mp_register_gsi(u32 gsi, int triggering, int polarity)
 		return gsi;
 	}
 	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
-		pr_debug(KERN_DEBUG "Pin %d-%d already programmed\n",
+		pr_debug("Pin %d-%d already programmed\n",
 			 mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
 #ifdef CONFIG_X86_32
 		return (gsi < IRQ_COMPRESSION_START ? gsi : gsi_to_irq[gsi]);
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 0e67f72..ce9b4d1 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -213,7 +213,7 @@ static void __init setup_node_to_cpumask_map(void)
 	/* allocate the map */
 	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
 
-	pr_debug(KERN_DEBUG "Node to cpumask map at %p for %d nodes\n",
+	pr_debug("Node to cpumask map at %p for %d nodes\n",
 		 map, nr_node_ids);
 
 	/* node_to_cpumask() will now work */
-- 
1.5.6.4

