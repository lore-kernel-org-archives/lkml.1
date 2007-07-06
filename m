Return-Path: <linux-kernel-owner+w=401wt.eu-S1763584AbXGFJ12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763584AbXGFJ12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758770AbXGFJ1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:27:20 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51940 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758831AbXGFJ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:27:19 -0400
Date: Fri, 6 Jul 2007 18:28:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, mel@csn.ul.ie
Subject: [PATCH] memory unplug v7 [6/6] - ia64 interface
Message-Id: <20070706182806.11b251b0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070706181903.428c3713.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070706181903.428c3713.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IA64 memory unplug interface.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 arch/ia64/mm/init.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc6-mm1/arch/ia64/mm/init.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/ia64/mm/init.c
+++ linux-2.6.22-rc6-mm1/arch/ia64/mm/init.c
@@ -724,7 +724,17 @@ int arch_add_memory(int nid, u64 start, 
 
 int remove_memory(u64 start, u64 size)
 {
-	return -EINVAL;
+	unsigned long start_pfn, end_pfn;
+	unsigned long timeout = 120 * HZ;
+	int ret;
+	start_pfn = start >> PAGE_SHIFT;
+	end_pfn = start_pfn + (size >> PAGE_SHIFT);
+	ret = offline_pages(start_pfn, end_pfn, timeout);
+	if (ret)
+		goto out;
+	/* we can free mem_map at this point */
+out:
+	return ret;
 }
 EXPORT_SYMBOL_GPL(remove_memory);
 #endif

