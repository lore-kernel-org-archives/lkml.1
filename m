Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbXLJVGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbXLJVGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 16:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbXLJVFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 16:05:22 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:52389 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbXLJVFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 16:05:19 -0500
X-SBRS: 5.6
X-MesageID: 33292000
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,148,1196658000"; 
   d="scan'208";a="33292000"
Message-ID: <475DA7C2.3020507@goop.org>
Date: Mon, 10 Dec 2007 12:55:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: [PATCH 1/4] kill mk_pte_huge
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It only has a single use, which can be trivially replaced.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>

---
 arch/x86/mm/init_64.c        |    3 +--
 include/asm-x86/pgtable_64.h |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

===================================================================
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -770,8 +770,7 @@ int __meminit vmemmap_populate(struct pa
 			if (!p)
 				return -ENOMEM;
 
-			entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
-			mk_pte_huge(entry);
+			entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL_LARGE);
 			set_pmd(pmd, __pmd(pte_val(entry)));
 
 			printk(KERN_DEBUG " [%lx-%lx] PMD ->%p on node %d\n",
===================================================================
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -352,7 +352,6 @@ static inline int pmd_large(pmd_t pte) {
 
 /* page, protection -> pte */
 #define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
-#define mk_pte_huge(entry) (pte_val(entry) |= _PAGE_PRESENT | _PAGE_PSE)
  
 /* Change flags of a PTE */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)


