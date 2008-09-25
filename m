Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYIYCGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYIYCGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYIYCFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:05:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:61605 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYIYCFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i0Y/FYQ1kWfhXMLmUrUBHgKJnOJ3Bggt+2fCjNaRClWBFG0VMpN+Aq1tGahvADzDC2
         oTQPj+Afif+vmgjV+nN9c2LOuUSE0QbUtbSHZ4tlt3Nivp9ehAfkFhMCuP1JpOI9ikCP
         95K9GOLnTtX7Qa1S3AW1Y8ezGpPDLUSFH7huw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/7] mm: print out meminit for memmap
Date: Wed, 24 Sep 2008 19:04:34 -0700
Message-Id: <1222308277-10984-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com>
References: <1222308277-10984-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 mm/page_alloc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e293c58..db30af6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3425,8 +3425,8 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
 		if (realsize >= memmap_pages) {
 			realsize -= memmap_pages;
-			mminit_dprintk(MMINIT_TRACE, "memmap_init",
-				"%s zone: %lu pages used for memmap\n",
+			printk(KERN_DEBUG
+				"  %s zone: %lu pages used for memmap\n",
 				zone_names[j], memmap_pages);
 		} else
 			printk(KERN_WARNING
@@ -3436,8 +3436,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		/* Account for reserved pages */
 		if (j == 0 && realsize > dma_reserve) {
 			realsize -= dma_reserve;
-			mminit_dprintk(MMINIT_TRACE, "memmap_init",
-					"%s zone: %lu pages reserved\n",
+			printk(KERN_DEBUG "  %s zone: %lu pages reserved\n",
 					zone_names[0], dma_reserve);
 		}
 
-- 
1.5.6

