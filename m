Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZLBEh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZLBEh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZLBEh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:37:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:36773 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbZLBEha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764916"
Message-Id: <20091202043043.840044332@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/24] migrate: page could be locked by hwpoison, dont BUG()
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=hwpoison-migrate-trylock-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new page could be taken by hwpoison, in which case
return EAGAIN to allocate a new page and retry.

CC: Nick Piggin <npiggin@suse.de>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-mm.orig/mm/migrate.c	2009-11-02 10:18:45.000000000 +0800
+++ linux-mm/mm/migrate.c	2009-11-02 10:26:16.000000000 +0800
@@ -556,7 +556,7 @@ static int move_to_new_page(struct page 
 	 * holding a reference to the new page at this point.
 	 */
 	if (!trylock_page(newpage))
-		BUG();
+		return -EAGAIN;		/* got by hwpoison */
 
 	/* Prepare mapping for the new page.*/
 	newpage->index = page->index;


