Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZDNLLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZDNLLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbZDNLKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:10:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZDNLKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:10:02 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
Subject: [PATCH 3/6] Handle possible bio_alloc failure in submit_bh
Date: Tue, 14 Apr 2009 16:36:39 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200904141636.39780.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle possible bio_alloc failure in submit_bh.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -2922,6 +2922,8 @@ int submit_bh(int rw, struct buffer_head
 	 * submit_bio -> generic_make_request may further map this bio around
 	 */
 	bio = bio_alloc(GFP_NOIO, 1);
+	if (unlikely(!bio))
+		panic("Failed to allocate bio\n");
 
 	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;


