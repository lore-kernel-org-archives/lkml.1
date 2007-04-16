Return-Path: <linux-kernel-owner+w=401wt.eu-S1030972AbXDPVRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030972AbXDPVRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030973AbXDPVRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:17:00 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:14998 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030972AbXDPVQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:16:59 -0400
X-IronPort-AV: i="4.14,415,1170662400"; 
   d="scan'208"; a="412057042:sNHT140263350"
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 16 Apr 2007 14:16:54 -0700
Message-ID: <aday7ks6mux.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Apr 2007 21:16:54.0943 (UTC) FILETIME=[8F204AF0:01C7806C]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a one-liner that fixes data corruption seen with storage
over iSER:

Michael S. Tsirkin (1):
      IB/mthca: Fix data corruption after FMR unmap on Sinai

 drivers/infiniband/hw/mthca/mthca_mr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/infiniband/hw/mthca/mthca_mr.c b/drivers/infiniband/hw/mthca/mthca_mr.c
index fdb576d..ee561c5 100644
--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -835,6 +835,7 @@ void mthca_arbel_fmr_unmap(struct mthca_dev *dev, struct mthca_fmr *fmr)
 
 	key = arbel_key_to_hw_index(fmr->ibmr.lkey);
 	key &= dev->limits.num_mpts - 1;
+	key = adjust_key(dev, key);
 	fmr->ibmr.lkey = fmr->ibmr.rkey = arbel_hw_index_to_key(key);
 
 	fmr->maps = 0;
