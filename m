Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbZELX30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbZELX30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbZELXZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:25:32 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36197
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753812AbZELXZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:25:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/17] xen: don't setup acpi interrupt unless there is one
Date: Tue, 12 May 2009 16:25:18 -0700
Message-Id: <1242170724-13349-12-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170724-13349-1-git-send-email-jeremy@goop.org>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If the SCI hasn't been set, then presumably we're not running
with acpi, don't bother setting up the interrupt.

[ Impact: compatibility with pre-ACPI machines ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index 402a5bd..00ad6df 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -69,13 +69,12 @@ void __init xen_setup_pirqs(void)
 	/*
 	 * Set up acpi interrupt in acpi_gbl_FADT.sci_interrupt.
 	 */
-	irq = xen_allocate_pirq(acpi_gbl_FADT.sci_interrupt);
+	if (acpi_gbl_FADT.sci_interrupt > 0) {
+		irq = xen_allocate_pirq(acpi_gbl_FADT.sci_interrupt);
 
-	printk(KERN_INFO "xen: allocated irq %d for acpi %d\n",
-	       irq, acpi_gbl_FADT.sci_interrupt);
-
-	/* Blerk. */
-	acpi_gbl_FADT.sci_interrupt = irq;
+		printk(KERN_INFO "xen: allocated irq %d for acpi %d\n",
+		       irq, acpi_gbl_FADT.sci_interrupt);
+	}
 #endif
 
 	/* Pre-allocate legacy irqs */
-- 
1.6.0.6

