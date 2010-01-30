Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283Ab0A3Jir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0A3Jir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 04:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114Ab0A3Jio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 04:38:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:59113 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab0A3Jim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 04:38:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,373,1262592000"; 
   d="scan'208";a="488322758"
Message-Id: <20100130093704.146687888@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 30 Jan 2010 17:25:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
to: Andi Kleen <andi@firstfloor.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>
cc: Nick Piggin <npiggin@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 4/4] hwpoison: avoid "still referenced by -1 users" warning
References: <20100130092509.793222613@intel.com>
Content-Disposition: inline; filename=hwpoison-no-warn-unknown.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the amusing last line, emitted for slab/reserved kernel pages:

[  328.396842] MCE 0x1ff00: Unknown page state
[  328.399058] MCE 0x1ff00: dirty unknown page state page recovery: Failed
[  328.402465] MCE 0x1ff00: unknown page state page still referenced by -1 users

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-mm.orig/mm/memory-failure.c	2010-01-22 11:20:28.000000000 +0800
+++ linux-mm/mm/memory-failure.c	2010-01-30 17:23:40.000000000 +0800
@@ -803,7 +803,7 @@ static int page_action(struct page_state
 	count = page_count(p) - 1;
 	if (ps->action == me_swapcache_dirty && result == DELAYED)
 		count--;
-	if (count != 0) {
+	if (count > 0) {
 		printk(KERN_ERR
 		       "MCE %#lx: %s page still referenced by %d users\n",
 		       pfn, ps->msg, count);


