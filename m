Return-Path: <linux-kernel-owner+w=401wt.eu-S935555AbXGRW7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935555AbXGRW7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759615AbXGRW5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:57:40 -0400
Received: from mail.fieldses.org ([66.93.2.214]:42912 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758696AbXGRW5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:57:39 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, andros@citi.umich.edu,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 3/5] nfsd: remove unnecessary NULL checks from nfsd_cross_mnt
Date: Wed, 18 Jul 2007 18:57:28 -0400
Message-Id: <11847994503028-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <11847994503243-git-send-email-bfields@fieldses.org>
References: <20070713114228.3c171a90.akpm@linux-foundation.org>
 <11847994502579-git-send-email-bfields@fieldses.org>
 <11847994502502-git-send-email-bfields@fieldses.org>
 <11847994503243-git-send-email-bfields@fieldses.org>
Message-Id: <ca76105264283034a0f3d9d138bded79f5b2f87e.1184798679.git.bfields@citi.umich.edu>
In-Reply-To: <2ac9f179334dc7894bb58b1c2fb62837a07fbbdf.1184798679.git.bfields@citi.umich.edu>
References: <2ac9f179334dc7894bb58b1c2fb62837a07fbbdf.1184798679.git.bfields@citi.umich.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

We can now assume that rqst_exp_get_by_name() does not return NULL; so
clean up some unnecessary checks.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/nfsd/vfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index b8da5dd..5c97d0e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -120,14 +120,14 @@ nfsd_cross_mnt(struct svc_rqst *rqstp, struct dentry **dpp,
 		mntput(mnt);
 		goto out;
 	}
-	if (exp2 && ((exp->ex_flags & NFSEXP_CROSSMOUNT) || EX_NOHIDE(exp2))) {
+	if ((exp->ex_flags & NFSEXP_CROSSMOUNT) || EX_NOHIDE(exp2)) {
 		/* successfully crossed mount point */
 		exp_put(exp);
 		*expp = exp2;
 		dput(dentry);
 		*dpp = mounts;
 	} else {
-		if (exp2) exp_put(exp2);
+		exp_put(exp2);
 		dput(mounts);
 	}
 	mntput(mnt);
-- 
1.5.3.rc2

