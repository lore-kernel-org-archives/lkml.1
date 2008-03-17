Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbYCRFdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbYCRFdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYCRFYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:30 -0400
Received: from gw.goop.org ([64.81.55.164]:37848 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbYCRFYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:09 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 16 of 31] xen: use appropriate pte types
X-Mercurial-Node: 0a6a8ca6f5c2b2c1596db9ecfd221d08ade565de
Message-Id: <0a6a8ca6f5c2b2c1596d.1205797027@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert Xen pagetable handling to use appropriate *val_t types.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -214,35 +214,35 @@
 	xen_set_pmd(pmdp, __pmd(0));
 }
 
-unsigned long long xen_pte_val(pte_t pte)
+pteval_t xen_pte_val(pte_t pte)
 {
-	unsigned long long ret = 0;
+	pteval_t ret = 0;
 
 	if (pte.pte_low) {
-		ret = ((unsigned long long)pte.pte_high << 32) | pte.pte_low;
+		ret = ((pteval_t)pte.pte_high << 32) | pte.pte_low;
 		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
 	}
 
 	return ret;
 }
 
-unsigned long long xen_pmd_val(pmd_t pmd)
+pmdval_t xen_pmd_val(pmd_t pmd)
 {
-	unsigned long long ret = pmd.pmd;
+	pmdval_t ret = pmd.pmd;
 	if (ret)
 		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
 	return ret;
 }
 
-unsigned long long xen_pgd_val(pgd_t pgd)
+pgdval_t xen_pgd_val(pgd_t pgd)
 {
-	unsigned long long ret = pgd.pgd;
+	pgdval_t ret = pgd.pgd;
 	if (ret)
 		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
 	return ret;
 }
 
-pte_t xen_make_pte(unsigned long long pte)
+pte_t xen_make_pte(pteval_t pte)
 {
 	if (pte & _PAGE_PRESENT) {
 		pte = phys_to_machine(XPADDR(pte)).maddr;
@@ -252,7 +252,7 @@
 	return (pte_t){ .pte = pte };
 }
 
-pmd_t xen_make_pmd(unsigned long long pmd)
+pmd_t xen_make_pmd(pmdval_t pmd)
 {
 	if (pmd & 1)
 		pmd = phys_to_machine(XPADDR(pmd)).maddr;
@@ -260,7 +260,7 @@
 	return (pmd_t){ pmd };
 }
 
-pgd_t xen_make_pgd(unsigned long long pgd)
+pgd_t xen_make_pgd(pgdval_t pgd)
 {
 	if (pgd & _PAGE_PRESENT)
 		pgd = phys_to_machine(XPADDR(pgd)).maddr;
@@ -273,9 +273,9 @@
 	*ptep = pte;
 }
 
-unsigned long xen_pte_val(pte_t pte)
+pteval_t xen_pte_val(pte_t pte)
 {
-	unsigned long ret = pte.pte_low;
+	pteval_t ret = pte.pte_low;
 
 	if (ret & _PAGE_PRESENT)
 		ret = machine_to_phys(XMADDR(ret)).paddr;
@@ -283,15 +283,15 @@
 	return ret;
 }
 
-unsigned long xen_pgd_val(pgd_t pgd)
+pgdval_t xen_pgd_val(pgd_t pgd)
 {
-	unsigned long ret = pgd.pgd;
+	pteval_t ret = pgd.pgd;
 	if (ret)
 		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
 	return ret;
 }
 
-pte_t xen_make_pte(unsigned long pte)
+pte_t xen_make_pte(pteval_t pte)
 {
 	if (pte & _PAGE_PRESENT) {
 		pte = phys_to_machine(XPADDR(pte)).maddr;
@@ -301,7 +301,7 @@
 	return (pte_t){ pte };
 }
 
-pgd_t xen_make_pgd(unsigned long pgd)
+pgd_t xen_make_pgd(pgdval_t pgd)
 {
 	if (pgd & _PAGE_PRESENT)
 		pgd = phys_to_machine(XPADDR(pgd)).maddr;


