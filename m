Return-Path: <linux-kernel-owner+w=401wt.eu-S1763467AbXGFQEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763467AbXGFQEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 12:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761816AbXGFQD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 12:03:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39294 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760418AbXGFQD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 12:03:56 -0400
Subject: [PATCH] mm: double mark_page_accessed() in read_cache_page_async()
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <npiggin@suse.de>, riel <riel@redhat.com>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 18:03:54 +0200
Message-Id: <1183737834.7054.108.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

read_cache_page_async() seems to have two invocations of
mark_page_accessed() which will launch pages right onto the active list.

Remove the first one, keeping the latter one. This avoids marking
unwanted pages active (in the retry loop).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/filemap.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -1588,7 +1588,6 @@ retry:
 	page = __read_cache_page(mapping, index, filler, data);
 	if (IS_ERR(page))
 		return page;
-	mark_page_accessed(page);
 	if (PageUptodate(page))
 		goto out;
 


