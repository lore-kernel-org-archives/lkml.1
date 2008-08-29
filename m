Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYH2MNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYH2MNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 08:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbYH2MNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 08:13:16 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:14954 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbYH2MNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 08:13:16 -0400
Message-Id: <48B80446.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 13:14:30 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: reduce boot fixmap space
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like for 32-bit - as 256 entries are needed, aligning to a
256-entry boundary is sufficient and still guarantees the single pte
table requirement.

Likewise move up __end_of_permanent_fixed_addresses, to match 32-bit.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 include/asm-x86/fixmap_64.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.27-rc5/include/asm-x86/fixmap_64.h	2008-08-29 10:53:26.000000000 +0200
+++ 2.6.27-rc5-x86_64-btmap-fixmap/include/asm-x86/fixmap_64.h	2008-08-22 15:24:33.000000000 +0200
@@ -49,6 +49,7 @@ enum fixed_addresses {
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
+	__end_of_permanent_fixed_addresses,
 #ifdef CONFIG_ACPI
 	FIX_ACPI_BEGIN,
 	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
@@ -56,18 +57,17 @@ enum fixed_addresses {
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
-	__end_of_permanent_fixed_addresses,
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
 	 *
-	 * We round it up to the next 512 pages boundary so that we
+	 * We round it up to the next 256 pages boundary so that we
 	 * can have a single pgd entry and a single pte table:
 	 */
 #define NR_FIX_BTMAPS		64
 #define FIX_BTMAPS_NESTING	4
-	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 512 -
-			(__end_of_permanent_fixed_addresses & 511),
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
+			(__end_of_permanent_fixed_addresses & 255),
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
 	__end_of_fixed_addresses
 };



