Return-Path: <linux-kernel-owner+w=401wt.eu-S1761583AbXH1TK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761583AbXH1TK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760977AbXH1THt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:07:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58824 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757098AbXH1THi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:38 -0400
Message-Id: <20070828190734.595148818@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:19 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [28/36] Fix PAGE SIZE assumption in miscellaneous places
Content-Disposition: inline; filename=0028-Fix-PAGE-SIZE-assumption-in-miscellaneous-places.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix PAGE SIZE assumption in miscellaneous places.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a124250..c6102e8 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -258,7 +258,7 @@ int get_futex_key(u32 __user *uaddr, struct rw_semaphore *fshared,
 	err = get_user_pages(current, mm, address, 1, 0, 0, &page, NULL);
 	if (err >= 0) {
 		key->shared.pgoff =
-			page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+			page->index << (compound_order(page) - PAGE_SHIFT);
 		put_page(page);
 		return 0;
 	}
-- 
1.5.2.4

-- 
