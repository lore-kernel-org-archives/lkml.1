Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbXJWFmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbXJWFmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXJWFmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:42:23 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:28964 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXJWFmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:42:22 -0400
Date: Tue, 23 Oct 2007 07:42:20 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fix ll_rw_blk.c build on s390
Message-ID: <20071023054220.GC10055@osiris.boeblingen.de.ibm.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-3-git-send-email-jens.axboe@oracle.com> <20071023051316.GB10055@osiris.boeblingen.de.ibm.com> <20071023051640.GL16425@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023051640.GL16425@kernel.dk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

  CC      block/ll_rw_blk.o
block/ll_rw_blk.c: In function 'blk_rq_map_sg':
block/ll_rw_blk.c:1357: error: implicit declaration of function 'sg_dma_len'
block/ll_rw_blk.c:1357: error: lvalue required as left operand of assignment
block/ll_rw_blk.c:1358: error: implicit declaration of function 'sg_dma_address'
block/ll_rw_blk.c:1358: error: lvalue required as left operand of assignment
make[1]: *** [block/ll_rw_blk.o] Error 1
make: *** [block] Error 2

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 block/ll_rw_blk.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/block/ll_rw_blk.c
+++ linux-2.6/block/ll_rw_blk.c
@@ -1354,8 +1354,6 @@ new_segment:
 			else
 				sg = sg_next(sg);
 
-			sg_dma_len(sg) = 0;
-			sg_dma_address(sg) = 0;
 			sg_set_page(sg, bvec->bv_page);
 			sg->length = nbytes;
 			sg->offset = bvec->bv_offset;
