Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbXGKU5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbXGKU5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933161AbXGKU5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:57:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086AbXGKU5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:57:22 -0400
Date: Wed, 11 Jul 2007 21:57:01 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [2.6.23 PATCH 02/18] dm: bio_list prefetch removal
Message-ID: <20070711205701.GT24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alasdair G Kergon <agk@redhat.com>

Remove dubious prefetch from bio_list_for_each() macro.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-bio-list.h |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

Index: linux/drivers/md/dm-bio-list.h
===================================================================
--- linux.orig/drivers/md/dm-bio-list.h	2007-07-11 21:37:36.000000000 +0100
+++ linux/drivers/md/dm-bio-list.h	2007-07-11 21:37:37.000000000 +0100
@@ -8,7 +8,6 @@
 #define DM_BIO_LIST_H
 
 #include <linux/bio.h>
-#include <linux/prefetch.h>
 
 struct bio_list {
 	struct bio *head;
@@ -31,8 +30,7 @@ static inline void bio_list_init(struct 
 }
 
 #define bio_list_for_each(bio, bl) \
-	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
-	     bio = bio->bi_next)
+	for (bio = (bl)->head; bio; bio = bio->bi_next)
 
 static inline unsigned bio_list_size(const struct bio_list *bl)
 {
