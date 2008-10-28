Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYJ1HgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYJ1HgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 03:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYJ1Hfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 03:35:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:59926 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbYJ1Hfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 03:35:54 -0400
Message-ID: <4906C0A3.2070009@kernel.org>
Date: Tue, 28 Oct 2008 00:34:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: checkt rev 3 fadt correctly for physical_apic bit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix fadt version checking

FADT2_REVISION_ID is 3 aka rev 3 FADT. so need to use >= instead of >

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/genapic_flat_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/genapic_flat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6/arch/x86/kernel/genapic_flat_64.c
@@ -197,7 +197,7 @@ static int physflat_acpi_madt_oem_check(
 	 * regardless of how many processors are present (x86_64 ES7000
 	 * is an example).
 	 */
-	if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID &&
+	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
 		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
 		printk(KERN_DEBUG "system APIC only can use physical flat");
 		return 1;
