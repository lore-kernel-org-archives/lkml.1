Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYKMUNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYKMUNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYKMUNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:13:38 -0500
Received: from gw.goop.org ([64.81.55.164]:44593 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbYKMUNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:13:37 -0500
Message-ID: <491C8A6F.3000404@goop.org>
Date: Thu, 13 Nov 2008 12:13:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: [PATCH 3/2] mm/remap_pfn_range: restore missing flush
References: <491C61B1.10005@goop.org> <20081113195341.GA8299@cmpxchg.org>
In-Reply-To: <20081113195341.GA8299@cmpxchg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restore the cache flush and BUG_ON removed in the conversion to using
apply_to_page_range().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citix.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memory.c |    4 ++++
 1 file changed, 4 insertions(+)

===================================================================
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1484,6 +1484,8 @@
 	struct remap_data *rmd = data;
 	pte_t pte = pte_mkspecial(pfn_pte(rmd->pfn++, rmd->prot));
 
+	BUG_ON(!pte_none(*ptep));
+
 	set_pte_at(rmd->mm, addr, ptep, pte);
 
 	return 0;
@@ -1535,6 +1537,8 @@
 
 	BUG_ON(addr >= end);
 
+	flush_cache_range(vma, addr, end);
+
 	rmd.mm = mm;
 	rmd.pfn = pfn;
 	rmd.prot = prot;


