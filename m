Return-Path: <linux-kernel-owner+w=401wt.eu-S1762808AbZB1CQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762808AbZB1CQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbZB1COQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:14:16 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:46158
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754246AbZB1COM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:14:12 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@f9-builder (none)>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 05/10] x86/io_apic: add get_nr_irqs_gsi()
Date: Fri, 27 Feb 2009 18:14:03 -0800
Message-Id: <1235787248-18184-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235787248-18184-1-git-send-email-jeremy@goop.org>
References: <1235787248-18184-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@f9-builder.(none)>

Add get_nr_irqs_gsi() to return nr_irqs_gsi.  Xen will use this to
determine how many irqs it needs to reserve for hardware irqs.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/io_apic.c      |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 685f21b..b82ca76 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -168,6 +168,7 @@ extern void reinit_intr_remapped_IO_APIC(int);
 #endif
 
 extern void probe_nr_irqs_gsi(void);
+extern int get_nr_irqs_gsi(void);
 
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 6366384..b93a919 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3865,6 +3865,11 @@ void __init probe_nr_irqs_gsi(void)
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

