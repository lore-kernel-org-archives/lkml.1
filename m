Return-Path: <linux-kernel-owner+w=401wt.eu-S1423191AbXBPEpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423191AbXBPEpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423172AbXBPEpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:45:31 -0500
Received: from dsl092-017-127.sfo4.dsl.speakeasy.net ([66.92.17.127]:36052
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423173AbXBPEpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:45:21 -0500
Message-Id: <20070216022530.755967483@goop.org>
References: <20070216022449.739760547@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Feb 2007 18:24:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
Subject: [patch 04/21] Xen-paravirt: ===================================================================
Content-Disposition: inline; filename=fix-vmi-types.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-static void vmi_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
+static void vmi_set_pte_present(struct mm_struct *mm, u32 addr, pte_t *ptep, pte_t pte)
 {
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);
 	vmi_ops.set_pte(pte, ptep, vmi_flags_addr_defer(mm, addr, VMI_PAGE_PT, 1));
@@ -492,7 +492,7 @@ static void vmi_set_pud(pud_t *pudp, pud
 	vmi_ops.set_pte(pte, (pte_t *)pudp, VMI_PAGE_PDP);
 }
 
-static void vmi_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+static void vmi_pte_clear(struct mm_struct *mm, u32 addr, pte_t *ptep)
 {
 	const pte_t pte = { 0 };
 	vmi_check_page_type(__pa(ptep) >> PAGE_SHIFT, VMI_PAGE_PTE);

-- 

