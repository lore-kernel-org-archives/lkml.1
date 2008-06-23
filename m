Return-Path: <linux-kernel-owner+w=401wt.eu-S1762814AbYFWTX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762814AbYFWTX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYFWTXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:23:50 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:63206 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYFWTXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:23:49 -0400
X-IronPort-AV: E=Sophos;i="4.27,691,1204531200"; 
   d="scan'208";a="82715215"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Mon, 23 Jun 2008 12:23:47 -0700
Message-ID: <adaej6o5518.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jun 2008 19:23:47.0924 (UTC) FILETIME=[A906E140:01C8D566]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a fix for one rare bug seen by SGI on large clusters:

Eli Cohen (1):
      IB/mthca: Clear ICM pages before handing to FW

 drivers/infiniband/hw/mthca/mthca_memfree.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index b224079..d5862e5 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -109,7 +109,11 @@ static int mthca_alloc_icm_pages(struct scatterlist *mem, int order, gfp_t gfp_m
 {
 	struct page *page;
 
-	page = alloc_pages(gfp_mask, order);
+	/*
+	 * Use __GFP_ZERO because buggy firmware assumes ICM pages are
+	 * cleared, and subtle failures are seen if they aren't.
+	 */
+	page = alloc_pages(gfp_mask | __GFP_ZERO, order);
 	if (!page)
 		return -ENOMEM;
 
