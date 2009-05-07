Return-Path: <linux-kernel-owner+w=401wt.eu-S1763657AbZEHAVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763657AbZEHAVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759328AbZEHAKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:25 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52705
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755378AbZEHAJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:59 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/18] xen: don't setup acpi interrupt unless there is one
Date: Thu,  7 May 2009 14:14:35 -0700
Message-Id: <1241730883-4917-11-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730883-4917-1-git-send-email-jeremy@goop.org>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: compatibility with non-ACPI machines

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

