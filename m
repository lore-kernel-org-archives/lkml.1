Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYJIFbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYJIFbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 01:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbYJIFbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 01:31:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:46547 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148AbYJIFbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 01:31:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,382,1220252400"; 
   d="scan'208";a="57229870"
Subject: [patch]x86: arch_add_memory round up address
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 13:31:30 +0800
Message-Id: <1223530290.30941.9.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Round up address to a page, otherwise the last page isn't mapped.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/mm/init_64.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c	2008-10-09 11:42:33.000000000 +0800
+++ linux/arch/x86/mm/init_64.c	2008-10-09 11:43:22.000000000 +0800
@@ -721,7 +721,8 @@ int arch_add_memory(int nid, u64 start, 
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	last_mapped_pfn = init_memory_mapping(start, start + size-1);
+	last_mapped_pfn = init_memory_mapping(start,
+		round_up(start + size-1, PAGE_SIZE));
 	if (last_mapped_pfn > max_pfn_mapped)
 		max_pfn_mapped = last_mapped_pfn;
 


