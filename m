Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbXKLQt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbXKLQt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbXKLQts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:49:48 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:17532 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbXKLQtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:49:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=M8fEuQaPpU2SNKAddwPVFCKDdijokkwutpHmt0d/+73ArkxECFQoDuYEdrd+FqSh6rCtHpBX1Nr3GaGYRnoytUnHzo94PQCz6IBsWMxXt5cjRPO6tvJcyhiDM390vatnRiFEsAaaCx/JXgORlmoOkz6sU4QMYpTyxT3bJgmSWbE=
From: Denis Cheng <crquan@gmail.com>
To: Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Denis Cheng <crquan@gmail.com>
Subject: [PATCH] SLUB: killed the unused "end" variable
Date: Tue, 13 Nov 2007 00:49:42 +0800
Message-Id: <1194886182-2330-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the macro "for_each_object" introduced, the "end" variable becomes unused anymore.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 mm/slub.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 84f59fd..9acb413 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1080,7 +1080,6 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 	struct page *page;
 	struct kmem_cache_node *n;
 	void *start;
-	void *end;
 	void *last;
 	void *p;
 
@@ -1101,7 +1100,6 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 		SetSlabDebug(page);
 
 	start = page_address(page);
-	end = start + s->objects * s->size;
 
 	if (unlikely(s->flags & SLAB_POISON))
 		memset(start, POISON_INUSE, PAGE_SIZE << s->order);
-- 
1.5.3.4

