Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYBYA1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYBYA1D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYBYAZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:25:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:9622 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbYBYAZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:25:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VzQdEZTZKjMSZ+GFDWcqela67iF/XyWEbVbz0jlEWjAt6Ot2C2netVJ6fIzOSNmvhfmxzSdTuo/AngNzIxYp3V+hcIbOUvlNjwSIcze/eygT2kQpetKaTyQdFHmF0c8PuDTaENU4pCLbZsbYyNZ7iW5ZCEDY2HeDDl3M0QruTJY=
Subject: [PATCH 6/6] block: fix shadowed variable warning in blk-map.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <5ce117613299590dd08d11d24d3a33d9077fe2b0.1203898924.git.harvey.harrison@gmail.com>
References: <5ce117613299590dd08d11d24d3a33d9077fe2b0.1203898924.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 16:25:37 -0800
Message-Id: <1203899137.1767.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced between 2.6.25-rc2 and -rc3
block/blk-map.c:154:14: warning: symbol 'bio' shadows an earlier one
block/blk-map.c:110:13: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 block/blk-map.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 09f7fd0..f443c21 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -151,10 +151,10 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 	 */
 	if (len & queue_dma_alignment(q)) {
 		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;
-		struct bio *bio = rq->biotail;
+		struct bio *tail = rq->biotail;
 
-		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len += pad_len;
-		bio->bi_size += pad_len;
+		tail->bi_io_vec[tail->bi_vcnt - 1].bv_len += pad_len;
+		tail->bi_size += pad_len;
 		rq->data_len += pad_len;
 	}
 
-- 
1.5.4.2.200.g99e75

