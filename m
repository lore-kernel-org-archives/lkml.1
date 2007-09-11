Return-Path: <linux-kernel-owner+w=401wt.eu-S966407AbXIKGSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966407AbXIKGSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762548AbXIKGGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:06:03 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56544 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762071AbXIKGEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:36 -0400
Message-Id: <20070911060434.890764895@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:30 -0700
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
Subject: [40/41] Do not use f_mapping in simple_prepare_write()
Content-Disposition: inline; filename=0042-Do-not-use-f_mapping-in-simple_prepare_write.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that simple_prepare_write() may occasionally be called for a page
that does not have a mapping yet. Retrieve the page size from the page
instead of the mapping.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/libfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2007-09-05 01:22:02.000000000 -0700
+++ linux-2.6/fs/libfs.c	2007-09-05 01:52:34.000000000 -0700
@@ -341,10 +341,10 @@ int simple_prepare_write(struct file *fi
 			unsigned from, unsigned to)
 {
 	if (!PageUptodate(page)) {
-		if (to - from != page_cache_size(file->f_mapping))
+		if (to - from != page_cache_page_size(page))
 			zero_user_segments(page,
 				0, from,
-				to, page_cache_size(file->f_mapping));
+				to, page_cache_page_size(page));
 	}
 	return 0;
 }

-- 
