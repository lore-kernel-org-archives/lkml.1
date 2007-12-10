Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbXLJVFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbXLJVFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 16:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbXLJVEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 16:04:55 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:14751 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321AbXLJVEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 16:04:54 -0500
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2007 16:04:52 EST
X-SBRS: 5.6
X-MesageID: 33291994
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,148,1196658000"; 
   d="scan'208";a="33291994"
Message-ID: <475DA7BF.4090200@goop.org>
Date: Mon, 10 Dec 2007 12:55:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: [PATCH 2/4] x86: clean up mm/init_32.c
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some code reformatting in init_32.c.  No functional change.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>

---
 arch/x86/mm/init_32.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

===================================================================
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -165,16 +165,25 @@ static void __init kernel_physical_mappi
 		pmd = one_md_table_init(pgd);
 		if (pfn >= max_low_pfn)
 			continue;
-		for (pmd_idx = 0; pmd_idx < PTRS_PER_PMD && pfn < max_low_pfn; pmd++, pmd_idx++) {
+		for (pmd_idx = 0;
+		     pmd_idx < PTRS_PER_PMD && pfn < max_low_pfn;
+		     pmd++, pmd_idx++) {
 			unsigned int address = pfn * PAGE_SIZE + PAGE_OFFSET;
 
-			/* Map with big pages if possible, otherwise create normal page tables. */
+			/* Map with big pages if possible, otherwise
+			   create normal page tables. */
 			if (cpu_has_pse) {
-				unsigned int address2 = (pfn + PTRS_PER_PTE - 1) * PAGE_SIZE + PAGE_OFFSET + PAGE_SIZE-1;
-				if (is_kernel_text(address) || is_kernel_text(address2))
-					set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
-				else
-					set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE));
+				unsigned int address2;
+				pgprot_t prot = PAGE_KERNEL_LARGE;
+
+				address2 = (pfn + PTRS_PER_PTE - 1) * PAGE_SIZE +
+					PAGE_OFFSET + PAGE_SIZE-1;
+
+				if (is_kernel_text(address) ||
+				    is_kernel_text(address2))
+					prot = PAGE_KERNEL_LARGE_EXEC;
+
+				set_pmd(pmd, pfn_pmd(pfn, prot));
 
 				pfn += PTRS_PER_PTE;
 			} else {
@@ -183,10 +192,12 @@ static void __init kernel_physical_mappi
 				for (pte_ofs = 0;
 				     pte_ofs < PTRS_PER_PTE && pfn < max_low_pfn;
 				     pte++, pfn++, pte_ofs++, address += PAGE_SIZE) {
+					pgprot_t prot = PAGE_KERNEL;
+
 					if (is_kernel_text(address))
-						set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
-					else
-						set_pte(pte, pfn_pte(pfn, PAGE_KERNEL));
+						prot = PAGE_KERNEL_EXEC;
+
+					set_pte(pte, pfn_pte(pfn, prot));
 				}
 			}
 		}


