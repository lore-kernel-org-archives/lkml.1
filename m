Return-Path: <linux-kernel-owner+w=401wt.eu-S1765649AbYDVPRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765649AbYDVPRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbYDVPRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:17:32 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15765 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbYDVPRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:17:32 -0400
Message-Id: <480E1DB9.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:17:45 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: move FIX_ACPI_* into non-permanent range
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. as they are used at early boot time only.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 include/asm-x86/fixmap_32.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.25/include/asm-x86/fixmap_32.h	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-i386-fixmap-acpi-non-permanent/include/asm-x86/fixmap_32.h	2008-04-15 10:49:20.000000000 +0200
@@ -79,10 +79,6 @@ enum fixed_addresses {
 	FIX_KMAP_BEGIN,	/* reserved pte's for temporary kernel mappings */
 	FIX_KMAP_END = FIX_KMAP_BEGIN+(KM_TYPE_NR*NR_CPUS)-1,
 #endif
-#ifdef CONFIG_ACPI
-	FIX_ACPI_BEGIN,
-	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
-#endif
 #ifdef CONFIG_PCI_MMCONFIG
 	FIX_PCIE_MCFG,
 #endif
@@ -104,6 +100,10 @@ enum fixed_addresses {
 			(__end_of_permanent_fixed_addresses & 511),
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
 	FIX_WP_TEST,
+#ifdef CONFIG_ACPI
+	FIX_ACPI_BEGIN,
+	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
+#endif
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif



