Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZCCN3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZCCN3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZCCN27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:28:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57030 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbZCCN26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:28:58 -0500
Message-ID: <49AD3033.4090608@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 21:27:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>
Subject: [PATCH -mm] slqb: use correct name for rcu callback
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


struct slqb_page defines struct rcu_head rcu_head for rcu,
the rcu callback should use it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/mm/slqb.c b/mm/slqb.c
index 07bf5b3..48bdf3b 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -1026,7 +1043,7 @@ static void rcu_free_slab(struct rcu_head *h)
 {
 	struct slqb_page *page;
 
-	page = container_of((struct list_head *)h, struct slqb_page, lru);
+	page = container_of(h, struct slqb_page, rcu_head);
 	__free_slab(page->list->cache, page);
 }
 


