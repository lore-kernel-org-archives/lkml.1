Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbXKGBOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbXKGBOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbXKGBMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:12:33 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33729 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755153AbXKGBM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:12:28 -0500
Message-Id: <20071107011227.588177188@sgi.com>
References: <20071107011130.382244340@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 17:11:35 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundatin.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Mel Gorman <mel@skynet.ie>
Subject: [patch 05/23] VM: Allow get_page_unless_zero on compound pages
Content-Disposition: inline; filename=0011-slab_defrag_get_page_unless.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB uses compound pages for larger slabs. We need to increment
the page count of these pages in order to make sure that they are not
freed under us because of other operations on the slab that may
independently remove the objects.

[This patch is already in mm]

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-mm1/include/linux/mm.h
===================================================================
--- linux-2.6.23-mm1.orig/include/linux/mm.h	2007-10-12 18:15:57.000000000 -0700
+++ linux-2.6.23-mm1/include/linux/mm.h	2007-10-12 18:17:30.000000000 -0700
@@ -227,7 +227,7 @@ static inline int put_page_testzero(stru
  */
 static inline int get_page_unless_zero(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page));
+	VM_BUG_ON(PageTail(page));
 	return atomic_inc_not_zero(&page->_count);
 }
 

-- 
