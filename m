Return-Path: <linux-kernel-owner+w=401wt.eu-S937337AbXGNB4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937337AbXGNB4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760736AbXGNB4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:56:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:43565 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbXGNB4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=D9+40SCHQNbYaGYag5iF1AlR+HHbUmFgHir7RAgyFph5W0kRll30m2+6bAzbJJrMlsmDfqzoAS/2ZdoTjOFAQitQs66qgLouSJai63/TCak9fwf9oGl7Qeav04ucnq5X+832Yu+0GAal4Et3nIRzw4E25XjfsIv1BwxQHoDAUBU=
Date: Sat, 14 Jul 2007 10:46:38 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: William Irwin <wli@holomorphy.com>
Subject: [PATCH] hugetlb: use set_compound_page_dtor
Message-ID: <20070714014638.GA5601@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, William Irwin <wli@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use appropriate accessor function to set compound page destructor
function.

Cc:  William Irwin <wli@holomorphy.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6-git/mm/hugetlb.c
===================================================================
--- 2.6-git.orig/mm/hugetlb.c
+++ 2.6-git/mm/hugetlb.c
@@ -196,7 +196,7 @@ static void update_and_free_page(struct 
 				1 << PG_dirty | 1 << PG_active | 1 << PG_reserved |
 				1 << PG_private | 1<< PG_writeback);
 	}
-	page[1].lru.next = NULL;
+	set_compound_page_dtor(page, NULL);
 	set_page_refcounted(page);
 	__free_pages(page, HUGETLB_PAGE_ORDER);
 }
