Return-Path: <linux-kernel-owner+w=401wt.eu-S933307AbZKXPJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbZKXPJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933284AbZKXPJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:09:28 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57699 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933275AbZKXPHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:52 -0500
Message-Id: <20091124150758.718024000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:23 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 26/29] GRU - Add hugepage support
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_hugepages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add support for hugepages. Easier than I originally thought.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:36.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:38.000000000 -0600
@@ -192,10 +192,11 @@ static int non_atomic_pte_lookup(struct 
 {
 	struct page *page;
 
-	/* ZZZ Need to handle HUGE pages */
-	if (is_vm_hugetlb_page(vma))
-		return -EFAULT;
+#ifdef CONFIG_HUGETLB_PAGE
+	*pageshift = is_vm_hugetlb_page(vma) ? HPAGE_SHIFT : PAGE_SHIFT;
+#else
 	*pageshift = PAGE_SHIFT;
+#endif
 	if (get_user_pages
 	    (current, current->mm, vaddr, 1, write, 0, &page, NULL) <= 0)
 		return -EFAULT;

