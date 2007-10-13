Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXJMTD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXJMTD5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 15:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761639AbXJMTDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 15:03:50 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33323 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761058AbXJMTDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 15:03:49 -0400
Date: Sat, 13 Oct 2007 15:03:48 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, jens.axboe@oracle.com,
       iss_storagedev@hp.com
Subject: [PATCH] drivers/block/cpqarray,cciss: kill unused var
Message-ID: <20071013190348.GA19992@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The recent bio work and subsequent fixups created unused variables.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/block/cciss.c    |    1 -
 drivers/block/cpqarray.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 28d1457..27401d6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1191,7 +1191,6 @@ static inline void complete_buffers(struct bio *bio, int status)
 {
 	while (bio) {
 		struct bio *xbh = bio->bi_next;
-		int nr_sectors = bio_sectors(bio);
 
 		bio->bi_next = NULL;
 		bio_endio(bio, status ? 0 : -EIO);
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 3853c9a..568603d 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -981,9 +981,8 @@ static void start_io(ctlr_info_t *h)
 static inline void complete_buffers(struct bio *bio, int ok)
 {
 	struct bio *xbh;
-	while(bio) {
-		int nr_sectors = bio_sectors(bio);
 
+	while (bio) {
 		xbh = bio->bi_next;
 		bio->bi_next = NULL;
 		
