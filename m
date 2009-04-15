Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbZDOFLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbZDOFLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZDOFJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:09:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbZDOFJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:09:54 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/7] dio: Remove code handling bio_alloc failure with __GFP_WAIT
Date: Wed, 15 Apr 2009 10:35:52 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151035.53240.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove code handling bio_alloc failure with __GFP_WAIT.
GFP_KERNEL implies __GFP_WAIT.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/direct-io.c b/fs/direct-io.c
index da258e7..05763bb 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -307,8 +307,6 @@ dio_bio_alloc(struct dio *dio, struct block_device *bdev,
 	struct bio *bio;
 
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
-	if (bio == NULL)
-		return -ENOMEM;
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;

