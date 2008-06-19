Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYFSAjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYFSAjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYFSAjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:39:15 -0400
Received: from mga10.intel.com ([192.55.52.92]:13502 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755956AbYFSAjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:39:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,668,1204531200"; 
   d="scan'208";a="343109224"
Date: Thu, 19 Jun 2008 08:38:44 +0800
From: Kent Liu <kent.liu@linux.intel.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Don't calculate vm_total_pages twice when rebuild zonelists in
	online_pages()
Message-ID: <20080619003844.GA14121@wliu-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If zonelist is required to be rebuilt in online_pages(), there is no need
to recalculate vm_total_pages in that function, as it has been updated 
in the call build_all_zonelists().

Signed-off-by: Kent Liu <kent.liu@linux.intel.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/memory_hotplug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 833f854..896ddaf 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -429,7 +429,9 @@ int online_pages(unsigned long pfn, unsigned long nr_pages)
 
 	if (need_zonelists_rebuild)
 		build_all_zonelists();
-	vm_total_pages = nr_free_pagecache_pages();
+	else
+		vm_total_pages = nr_free_pagecache_pages();
+
 	writeback_set_ratelimit();
 
 	if (onlined_pages)
