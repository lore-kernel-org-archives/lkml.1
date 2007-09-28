Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbXI1Qf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbXI1Qf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXI1Qft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:35:49 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:44449 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbXI1Qfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:35:48 -0400
Date: Fri, 28 Sep 2007 17:35:45 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: [PATCH] hugetlb: Fix clear_user_highpage arguments
Message-ID: <20070928163545.GA5933@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The virtual address space argument of clear_user_highpage is supposed to
be the virtual address where the page being cleared will eventually be
mapped. This allows architectures with virtually indexed caches a few
clever tricks.  That sort of trick falls over in painful ways if the
virtual address argument is wrong.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 84c795e..eab8c42 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -42,7 +42,7 @@ static void clear_huge_page(struct page *page, unsigned long addr)
 	might_sleep();
 	for (i = 0; i < (HPAGE_SIZE/PAGE_SIZE); i++) {
 		cond_resched();
-		clear_user_highpage(page + i, addr);
+		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
 	}
 }
 
