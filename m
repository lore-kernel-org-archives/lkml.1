Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbXH0UXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbXH0UXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbXH0UW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:22:59 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43327 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356AbXH0UW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:22:58 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: linux-kernel@vger.kernel.org
Cc: nfs@lists.sourceforge.net, Neil Brown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 01/15] nfsd: tone down inaccurate dprintk
Date: Mon, 27 Aug 2007 16:22:42 -0400
Message-Id: <1188246176681-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.3.rc6.48.g17437
In-Reply-To: <11882461763072-git-send-email-bfields@fieldses.org>
References: <11882461763072-git-send-email-bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

The nfserr_dropit happens routinely on upcalls (so a kmalloc failure is
almost never the actual cause), but I occasionally get a complant from
some tester that's worried because they ran across this message after
turning on debugging to research some unrelated problem.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/nfsd/nfssvc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index a8c89ae..221eeaa 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -549,7 +549,7 @@ nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 	if (nfserr == nfserr_jukebox && rqstp->rq_vers == 2)
 		nfserr = nfserr_dropit;
 	if (nfserr == nfserr_dropit) {
-		dprintk("nfsd: Dropping request due to malloc failure!\n");
+		dprintk("nfsd: Dropping request; may be revisited later\n");
 		nfsd_cache_update(rqstp, RC_NOCACHE, NULL);
 		return 0;
 	}
-- 
1.5.3.rc5.19.g0734d

