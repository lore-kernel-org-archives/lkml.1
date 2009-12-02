Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZLBEiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZLBEiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbZLBEiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:38:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:36773 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbZLBEh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764898"
Message-Id: <20091202043044.432444976@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/24] HWPOISON: comment the possible set_page_dirty() race
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=hwpoison-comment-dirty.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Andi Kleen <andi@firstfloor.org> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-mm.orig/mm/memory-failure.c	2009-11-30 11:11:25.000000000 +0800
+++ linux-mm/mm/memory-failure.c	2009-11-30 11:12:41.000000000 +0800
@@ -667,6 +667,8 @@ static int hwpoison_user_mappings(struct
 	/*
 	 * Propagate the dirty bit from PTEs to struct page first, because we
 	 * need this to decide if we should kill or just drop the page.
+	 * XXX: the dirty test could be racy: set_page_dirty() may not always
+	 * be called inside page lock (it's recommended but not enforced).
 	 */
 	mapping = page_mapping(p);
 	if (!PageDirty(p) && mapping && mapping_cap_writeback_dirty(mapping)) {


