Return-Path: <linux-kernel-owner+w=401wt.eu-S966834AbXIKGYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966834AbXIKGYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762513AbXIKGG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:06:56 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56516 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761561AbXIKGEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:32 -0400
Message-Id: <20070911060432.071603646@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:18 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [28/41] Futex: Fix PAGE SIZE assumption
Content-Disposition: inline; filename=0028-Fix-PAGE-SIZE-assumption-in-miscellaneous-places.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 kernel/futex.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c	2007-09-05 01:19:50.000000000 -0700
+++ linux-2.6/kernel/futex.c	2007-09-05 01:37:04.000000000 -0700
@@ -258,7 +258,8 @@ int get_futex_key(u32 __user *uaddr, str
 	err = get_user_pages(current, mm, address, 1, 0, 0, &page, NULL);
 	if (err >= 0) {
 		key->shared.pgoff =
-			page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+			page->index <<
+				(page_cache_page_shift(page) - PAGE_SHIFT);
 		put_page(page);
 		return 0;
 	}

-- 
