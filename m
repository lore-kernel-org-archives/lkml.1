Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbZCMQqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbZCMQqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbZCMQnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:43:23 -0400
Received: from gw.goop.org ([64.81.55.164]:57279 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758920AbZCMQnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:43:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/17] xen: don't setup acpi interrupt unless there is one
Date: Fri, 13 Mar 2009 09:42:32 -0700
Message-Id: <1236962558-13748-12-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236962558-13748-1-git-send-email-jeremy@goop.org>
References: <1236962558-13748-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If the SCI hasn't been set, then presumably we're not running
with acpi, don't bother setting up the interrupt.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index fb408ce..e88f85e 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -68,13 +68,12 @@ void __init xen_setup_pirqs(void)
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

