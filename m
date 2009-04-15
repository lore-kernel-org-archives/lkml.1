Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbZDOFLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbZDOFLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZDOFJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:09:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:39342 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbZDOFJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:09:57 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/7] swap: Remove code handling bio_alloc failure with __GFP_WAIT
Date: Wed, 15 Apr 2009 10:37:04 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151037.04929.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove code handling bio_alloc failure with __GFP_WAIT.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 505f319..8ba052c 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -64,8 +64,6 @@ static int submit(int rw, pgoff_t page_off, struct page *page,
 	struct bio *bio;
 
 	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
-	if (!bio)
-		return -ENOMEM;
 	bio->bi_sector = page_off * (PAGE_SIZE >> 9);
 	bio->bi_bdev = resume_bdev;
 	bio->bi_end_io = end_swap_bio_read;

