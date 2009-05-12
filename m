Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZELX1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZELX1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZELXZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:25:28 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36191
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753163AbZELXZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:25:25 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@f9-builder (none)>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/17] x86/io_apic: add get_nr_irqs_gsi()
Date: Tue, 12 May 2009 16:25:13 -0700
Message-Id: <1242170724-13349-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170724-13349-1-git-send-email-jeremy@goop.org>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@f9-builder.(none)>

Add get_nr_irqs_gsi() to return nr_irqs_gsi.  Xen will use this to
determine how many irqs it needs to reserve for hardware irqs.

[ Impact: new interface to get max GSI ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/apic/io_apic.c |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 8cbfe73..e33ccb7 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -181,6 +181,7 @@ extern void reinit_intr_remapped_IO_APIC(int intr_remapping,
 #endif
 
 extern void probe_nr_irqs_gsi(void);
+extern int get_nr_irqs_gsi(void);
 
 extern int setup_ioapic_entry(int apic, int irq,
 			      struct IO_APIC_route_entry *entry,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c24f116..07dc530 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3917,6 +3917,11 @@ void __init probe_nr_irqs_gsi(void)
 	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
 }
 
+int get_nr_irqs_gsi(void)
+{
+	return nr_irqs_gsi;
+}
+
 #ifdef CONFIG_SPARSE_IRQ
 int __init arch_probe_nr_irqs(void)
 {
-- 
1.6.0.6

