Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622Ab0ANSuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab0ANSuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305Ab0ANSue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:50:34 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:47282 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160Ab0ANSue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:50:34 -0500
X-Trace: 327786222/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMBAOv1TktPRRyw/2dsb2JhbAAI2T6EMAQ
X-IronPort-AV: E=Sophos;i="4.49,276,1262563200"; 
   d="scan'208";a="327786222"
Date: Thu, 14 Jan 2010 18:50:22 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nitin Gupta <ngupta@vflare.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [mmotm v2] comment on swap notify locking constraints
In-Reply-To: <1263492602-3052-1-git-send-email-ngupta@vflare.org>
Message-ID: <alpine.LSU.2.00.1001141845110.15495@sister.anvils>
References: <1263492602-3052-1-git-send-email-ngupta@vflare.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin Gupta <ngupta@vflare.org>

A block device makes swap_slot_free_notify() callback
when the last reference to a swap slot is dropped.

This callback is made under swap_lock and sometimes page table
lock. This is a note of warning for registered callback
function which must meet these constraints.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
I've added "sometimes " in the comment above and the comment below:
sorry, I should have made that clearer when I made this point.

Hugh

 include/linux/blkdev.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f86df8b..fb7b3c2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1294,6 +1294,7 @@ struct block_device_operations {
 						unsigned long long);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
+	/* this callback is with swap_lock and sometimes page table lock held */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	struct module *owner;
 };
-- 
1.6.2.5
