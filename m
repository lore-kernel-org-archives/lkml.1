Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYCDJe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYCDJe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYCDJeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:34:14 -0500
Received: from mail.windriver.com ([147.11.1.11]:56104 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbYCDJeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:34:13 -0500
Message-ID: <47CD179B.3000806@windriver.com>
Date: Tue, 04 Mar 2008 17:34:19 +0800
From: yshi <yang.shi@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: axboe@kernel.dk
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix DMA access of block device in 64-bit kernel on some non-x86
 systems with 4GB or upper 4GB memory
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2008 09:34:07.0379 (UTC) FILETIME=[E4B9E630:01C87DDA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some non-x86 systems with 4GB or upper 4GB memory,
we need increase the range of addresses that can be
used for direct DMA in 64-bit kernel.

Signed-off-by: Yang Shi <yang.shi@windriver.com>
---
b/block/blk-settings.c |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)
---

--- a/block/blk-settings.c      2008-03-03 17:11:25.000000000 +0800
+++ b/block/blk-settings.c      2008-03-03 17:11:42.000000000 +0800
@@ -140,7 +140,7 @@ void blk_queue_bounce_limit(struct reque
       /* Assume anything <= 4GB can be handled by IOMMU.
          Actually some IOMMUs can handle everything, but I don't
          know of a way to test this here. */
-       if (b_pfn < (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> 
PAGE_SHIFT))
+       if (b_pfn <= (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> 
PAGE_SHIFT))
               dma = 1;
       q->bounce_pfn = max_low_pfn;
#else
