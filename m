Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYH0VaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYH0VaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYH0VaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:30:05 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:36035 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYH0VaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:30:03 -0400
X-IronPort-AV: E=Sophos;i="4.32,281,1217808000"; 
   d="scan'208";a="147869641"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: [PATCH] IB/mlx4: Actually return L_Key and R_Key for fast register MRs
X-Message-Flag: Warning: May contain useful information
Date: Wed, 27 Aug 2008 14:29:57 -0700
Message-ID: <adasksqf8oa.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Aug 2008 21:29:58.0201 (UTC) FILETIME=[0E1D3A90:01C9088C]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir Sokolovsky <vlad@mellanox.co.il>

Initialize the L_Key and R_Key for memory regions returned from
mlx4_ib_alloc_fast_reg_mr().  Otherwise callers just get garbage for
the memory keys and can't do anything useful with these MRs.

Signed-off-by: Vladimir Sokolovsky <vlad@mellanox.co.il>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
Hi Linus,

Please apply this for 2.6.27.  This fixes a new feature we merged during
the window but weren't able to test fully because device firmware wasn't
ready at the time.

I'm just sending this as a patch rather than a git pull request since I
think applying one patch from email is, if anything, easier than pulling
a git tree.  If you'd rather get singleton patches via git in the future
just let me know.

Thanks,
  Roland

 drivers/infiniband/hw/mlx4/mr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index a4cdb46..87f5c5a 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -204,6 +204,8 @@ struct ib_mr *mlx4_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 	if (err)
 		goto err_mr;
 
+	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
+
 	return &mr->ibmr;
 
 err_mr:
-- 
1.5.6.3

