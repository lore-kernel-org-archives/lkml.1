Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbXIUVBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbXIUVBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763973AbXIUUqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:46:55 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34991 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763597AbXIUUqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:46:54 -0400
Date: Fri, 21 Sep 2007 21:46:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] LBS: fix oops in try_to_release_page
In-Reply-To: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0709212145580.13529@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's uncommon, but try_to_release_page is sometimes called when
page->mapping is NULL (see the check for mapping further down):
so its VM_BUG_ON(mapping_order(mapping)...) just causes an oops.
There seem to be enough of those checks already, and no special
reason to have one right here: just delete it.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.23-rc6-lbs/mm/filemap.c	2007-09-11 20:01:08.000000000 +0100
+++ linux/mm/filemap.c	2007-09-14 12:00:06.000000000 +0100
@@ -2247,7 +2247,6 @@ int try_to_release_page(struct page *pag
 	struct address_space * const mapping = page->mapping;
 
 	BUG_ON(!PageLocked(page));
-	VM_BUG_ON(mapping_order(mapping) != page_cache_page_order(page));
 	if (PageWriteback(page))
 		return 0;
 
