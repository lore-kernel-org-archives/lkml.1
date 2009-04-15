Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZDOFKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZDOFKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZDOFJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:09:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:39328 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZDOFJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:09:53 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/7] Document that bio_alloc with __GFP_WAIT cannot fail
Date: Wed, 15 Apr 2009 10:35:04 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151035.04657.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document that bio_alloc with __GFP_WAIT cannot fail.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/bio.c b/fs/bio.c
index e0c9e54..5b5dfdd 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -348,6 +348,10 @@ err:
 	return NULL;
 }
 
+/*
+ * This will not fail as long as __GFP_WAIT is specified
+ * in the gfp_mask, as mempool backing is used.
+ */
 struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
 {
 	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);

