Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYAHWRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYAHWRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYAHWPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:15:38 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:47853
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752033AbYAHWPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:15:33 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 10] x86/vmi: fix compilation as a result of pte_t changes
X-Mercurial-Node: d4a31052e55d195a319fe6549672dd5a29e3dc18
Message-Id: <d4a31052e55d195a319f.1199829609@localhost>
In-Reply-To: <patchbomb.1199829603@localhost>
Date: Tue, 08 Jan 2008 14:00:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>, Zachary Amsden <zach@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix various compilation problems as a result of changing pte_t.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
---
 arch/x86/kernel/vmi_32.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -475,7 +475,7 @@ static void vmi_set_pmd(pmd_t *pmdp, pmd
 static void vmi_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 #ifdef CONFIG_X86_PAE
-	const pte_t pte = { pmdval.pmd, pmdval.pmd >> 32 };
+	const pte_t pte = { .pte = pmdval.pmd };
 	vmi_check_page_type(__pa(pmdp) >> PAGE_SHIFT, VMI_PAGE_PMD);
 #else
 	const pte_t pte = { pmdval.pud.pgd.pgd };
@@ -508,21 +508,21 @@ static void vmi_set_pud(pud_t *pudp, pud
 static void vmi_set_pud(pud_t *pudp, pud_t pudval)
 {
 	/* Um, eww */
-	const pte_t pte = { pudval.pgd.pgd, pudval.pgd.pgd >> 32 };
+	const pte_t pte = { .pte = pudval.pgd.pgd };
 	vmi_check_page_type(__pa(pudp) >> PAGE_SHIFT, VMI_PAGE_PGD);
 	vmi_ops.set_pte(pte, (pte_t *)pudp, VMI_PAGE_PDP);
 }
 
 static void vmi_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	const pte_t pte = { 0 };
+	const pte_t pte = { .pte = 0 };
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.set_pte(pte, ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
 }
 
 static void vmi_pmd_clear(pmd_t *pmd)
 {
-	const pte_t pte = { 0 };
+	const pte_t pte = { .pte = 0 };
 	vmi_check_page_type(__pa(pmd) >> PAGE_SHIFT, VMI_PAGE_PMD);
 	vmi_ops.set_pte(pte, (pte_t *)pmd, VMI_PAGE_PD);
 }


