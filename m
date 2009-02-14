Return-Path: <linux-kernel-owner+w=401wt.eu-S1764155AbZBNBYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764155AbZBNBYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762686AbZBNBNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:13:01 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:49174
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763638AbZBNBNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:13:00 -0500
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 20:12:59 EST
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@f9-builder (none)>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 5/9] x86/io_apic: add get_nr_irqs_gsi()
Date: Fri, 13 Feb 2009 17:12:03 -0800
Message-Id: <5b0148b366eaa87072ab261f71c4c545be8e607f.1234573847.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cbcff9ab54a2189156077c81c706fc30ba84344c.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <3c7db30686056c9b86cc61ef50dd5572de868512.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <3e46dae897fd5620f50b4cca9272969f5546aa88.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <79724b71f4b8ef1fb65ea246dde2e3e1344b2a43.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <cbcff9ab54a2189156077c81c706fc30ba84344c.1234573847.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
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
index 20b543a..10a7a43 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -168,6 +168,7 @@ extern void reinit_intr_remapped_IO_APIC(int);
 #endif
 
 extern void probe_nr_irqs_gsi(void);
+extern int get_nr_irqs_gsi(void);
 
 extern int setup_ioapic_entry(int apic, int irq,
 			      struct IO_APIC_route_entry *entry,
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index de0368a..f66c093 100644
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

