Return-Path: <linux-kernel-owner+w=401wt.eu-S1763298AbZB1CQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298AbZB1CQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbZB1COR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:14:17 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:46161
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754593AbZB1CON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:14:13 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/10] xen: pre-initialize legacy irqs early
Date: Fri, 27 Feb 2009 18:14:07 -0800
Message-Id: <1235787248-18184-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235787248-18184-1-git-send-email-jeremy@goop.org>
References: <1235787248-18184-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Various legacy devices, such as IDE, assume their legacy interrupts are
already initialized and are immediately usable.  Pre-initialize all the
legacy interrupts.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index 61f070c..d661c74 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -60,9 +60,9 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 
 void __init xen_setup_pirqs(void)
 {
-#ifdef CONFIG_ACPI
 	int irq;
 
+#ifdef CONFIG_ACPI
 	/*
 	 * Set up acpi interrupt in acpi_gbl_FADT.sci_interrupt.
 	 */
@@ -74,4 +74,8 @@ void __init xen_setup_pirqs(void)
 	/* Blerk. */
 	acpi_gbl_FADT.sci_interrupt = irq;
 #endif
+
+	/* Pre-allocate legacy irqs */
+	for (irq=0; irq < NR_IRQS_LEGACY; irq++)
+		xen_allocate_pirq(irq);
 }
-- 
1.6.0.6

