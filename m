Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbZCMQoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbZCMQoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759344AbZCMQnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:43:08 -0400
Received: from gw.goop.org ([64.81.55.164]:57269 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759314AbZCMQnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:43:07 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@f9-builder (none)>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 05/17] x86/io_apic: add get_nr_irqs_gsi()
Date: Fri, 13 Mar 2009 09:42:26 -0700
Message-Id: <1236962558-13748-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236962558-13748-1-git-send-email-jeremy@goop.org>
References: <1236962558-13748-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@f9-builder.(none)>

Add get_nr_irqs_gsi() to return nr_irqs_gsi.  Xen will use this to
determine how many irqs it needs to reserve for hardware irqs.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/apic/io_apic.c |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 20b543a..10a7a43 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -168,6 +168,7 @@ extern void reinit_intr_remapped_IO_APIC(int);
 #endif
 
 extern void probe_nr_irqs_gsi(void);
+extern int get_nr_irqs_gsi(void);
 
 extern int setup_ioapic_entry(int apic, int irq,
 			      struct IO_APIC_route_entry *entry,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6d14ff9..6da6f3c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3851,6 +3851,11 @@ void __init probe_nr_irqs_gsi(void)
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

