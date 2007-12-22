Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXLVBet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXLVBet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 20:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXLVBdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 20:33:25 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53943 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751306AbXLVBdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 20:33:18 -0500
Message-ID: <398287205.83154@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071222013314.978523200@mail.ustc.edu.cn>
References: <20071222013147.897522982@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sat, 22 Dec 2007 09:31:51 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] readahead: quick startup on sequential mmap readahead
Content-Disposition: inline; filename=readahead-sequential-quick-start.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the user explicitly sets MADV_SEQUENTIAL, we should really avoid the slow
readahead size ramp-up phase and start full-size readahead immediately.

This patch won't change behavior for the auto-detected sequential mmap reads.
Its previous read-around size is ra_pages/2, so it will be doubled to the full
readahead size anyway.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc5-mm1.orig/mm/filemap.c
+++ linux-2.6.24-rc5-mm1/mm/filemap.c
@@ -1320,7 +1320,7 @@ static void do_sync_mmap_readahead(struc
 
 	if (VM_SequentialReadHint(vma) ||
 			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
-		page_cache_sync_readahead(mapping, ra, file, offset, 1);
+		page_cache_sync_readahead(mapping, ra, file, offset, ra->ra_pages);
 		return;
 	}
 

-- 
