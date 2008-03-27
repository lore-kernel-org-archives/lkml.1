Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbYC0EFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbYC0EFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 00:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbYC0EFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 00:05:05 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52693 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750701AbYC0EFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 00:05:04 -0400
Date: Wed, 26 Mar 2008 21:03:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [x86] Stricter check in follow_huge_addr()
Message-ID: <Pine.LNX.4.64.0803262101060.2683@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Subject: Compound Pages: Stricter check in follow_huge_addr

The first page of the compound page is determined in follow_huge_addr()
but then PageCompound() only checks if the page is part of a compound page.
PageHead() allows checking if this is indeed the first page of the 
compound.

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.25-rc5-mm1/arch/x86/mm/hugetlbpage.c
===================================================================
--- linux-2.6.25-rc5-mm1.orig/arch/x86/mm/hugetlbpage.c	2008-03-26 20:43:56.796667401 -0700
+++ linux-2.6.25-rc5-mm1/arch/x86/mm/hugetlbpage.c	2008-03-26 20:44:55.526669888 -0700
@@ -178,7 +178,7 @@ follow_huge_addr(struct mm_struct *mm, u
 
 	page = &pte_page(*pte)[vpfn % (HPAGE_SIZE/PAGE_SIZE)];
 
-	WARN_ON(!PageCompound(page));
+	WARN_ON(!PageHead(page));
 
 	return page;
 }
