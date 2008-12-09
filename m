Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYLIQvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYLIQvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYLIQvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:51:35 -0500
Received: from relay1.sgi.com ([192.48.179.29]:52173 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753429AbYLIQve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:51:34 -0500
Date: Tue, 9 Dec 2008 10:51:32 -0600
From: Jack Steiner <steiner@sgi.com>
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: a.beregalov@gmail.com, kernel-testers@vger.kernel.org
Subject: [PATCH] - Fix GRU compile error w/o CONFIG_HUGETLB_PAGE
Message-ID: <20081209165132.GA26860@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate compile error when compiling without CONFIG_HUGETLB_PAGE.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2008-12-08 08:25:57.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2008-12-09 09:35:02.000000000 -0600
@@ -254,7 +254,11 @@ static int atomic_pte_lookup(struct vm_a
 		return 1;
 
 	*paddr = pte_pfn(pte) << PAGE_SHIFT;
+#ifdef CONFIG_HUGETLB_PAGE
 	*pageshift = is_vm_hugetlb_page(vma) ? HPAGE_SHIFT : PAGE_SHIFT;
+#else
+	*pageshift = PAGE_SHIFT;
+#endif
 	return 0;
 
 err:
