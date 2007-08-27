Return-Path: <linux-kernel-owner+w=401wt.eu-S1761198AbXH0UXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198AbXH0UXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759775AbXH0UXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:23:00 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43331 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758916AbXH0UW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:22:58 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: linux-kernel@vger.kernel.org
Cc: nfs@lists.sourceforge.net, Neil Brown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 04/15] knfsd: delete code made redundant by map_new_errors
Date: Mon, 27 Aug 2007 16:22:45 -0400
Message-Id: <11882461773576-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.3.rc6.48.g17437
In-Reply-To: <1188246177833-git-send-email-bfields@fieldses.org>
References: <11882461763072-git-send-email-bfields@fieldses.org>
 <1188246176681-git-send-email-bfields@fieldses.org>
 <1188246176897-git-send-email-bfields@fieldses.org>
 <1188246177833-git-send-email-bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

I moved this check into map_new_errors, but forgot to delete the
original.  Oops.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/nfsd/nfssvc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 221eeaa..ef46f32 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -546,8 +546,6 @@ nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 	/* Now call the procedure handler, and encode NFS status. */
 	nfserr = proc->pc_func(rqstp, rqstp->rq_argp, rqstp->rq_resp);
 	nfserr = map_new_errors(rqstp->rq_vers, nfserr);
-	if (nfserr == nfserr_jukebox && rqstp->rq_vers == 2)
-		nfserr = nfserr_dropit;
 	if (nfserr == nfserr_dropit) {
 		dprintk("nfsd: Dropping request; may be revisited later\n");
 		nfsd_cache_update(rqstp, RC_NOCACHE, NULL);
-- 
1.5.3.rc5.19.g0734d

