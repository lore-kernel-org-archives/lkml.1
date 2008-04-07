Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbYDGMuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbYDGMuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 08:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYDGMuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 08:50:07 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38188 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbYDGMuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 08:50:06 -0400
Date: Mon, 07 Apr 2008 21:46:19 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch 002/005](memory hotplug) align memmap to page size
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <20080407213519.886E.E1E9C6FF@jp.fujitsu.com>
References: <20080407213519.886E.E1E9C6FF@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080407214514.8872.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To free memmap easier, this patch aligns it to page size.
Bootmem allocater may mix some objects in one pages.
It's not good for freeing memmap of memory hot-remove.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 mm/sparse.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: current/mm/sparse.c
===================================================================
--- current.orig/mm/sparse.c	2008-04-07 19:18:50.000000000 +0900
+++ current/mm/sparse.c	2008-04-07 20:08:13.000000000 +0900
@@ -265,8 +265,8 @@
 	if (map)
 		return map;
 
-	map = alloc_bootmem_node(NODE_DATA(nid),
-			sizeof(struct page) * PAGES_PER_SECTION);
+	map = alloc_bootmem_pages_node(NODE_DATA(nid),
+		       PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION));
 	return map;
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */

-- 
Yasunori Goto 


