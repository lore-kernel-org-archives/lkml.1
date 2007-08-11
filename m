Return-Path: <linux-kernel-owner+w=401wt.eu-S1765012AbXHKTDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765012AbXHKTDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbXHKS63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:29 -0400
Received: from 1wt.eu ([62.212.114.60]:1563 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762504AbXHKS6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:23 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184843.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:07 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 15/28] dm crypt: disable barriers
Content-Disposition: inline; filename=0015-dm-crypt-disable-barriers.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Disable barriers in dm-crypt because of current workqueue processing can
reorder requests.

This must be addresed later but for now disabling barriers is needed to
prevent data corruption.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/dm-crypt.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 4c2471e..f68677d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -954,6 +954,9 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
 	struct crypt_config *cc = ti->private;
 	struct crypt_io *io;
 
+	if (bio_barrier(bio))
+		return -EOPNOTSUPP;
+
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;
-- 
1.5.2.4

-- 
