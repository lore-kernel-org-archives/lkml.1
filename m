Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbZDOI1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbZDOI1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbZDOI1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:27:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbZDOI1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:27:09 -0400
Date: Wed, 15 Apr 2009 10:27:07 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <axboe@kernel.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] brd: support barriers
Message-ID: <20090415082707.GA7685@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,
Do you have a tree I can send this though? Is this the right way to
do what I want?

--

brd is always ordered (not that it matters, as it is defined not to
survive when the system goes down). So tell the block layer it is
ordered, which might be of help with testing filesystems.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 drivers/block/brd.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -436,6 +436,7 @@ static struct brd_device *brd_alloc(int
 	if (!brd->brd_queue)
 		goto out_free_dev;
 	blk_queue_make_request(brd->brd_queue, brd_make_request);
+	blk_queue_ordered(brd->brd_queue, QUEUE_ORDERED_TAG, NULL);
 	blk_queue_max_sectors(brd->brd_queue, 1024);
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
 
