Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbXKNCHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbXKNCHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760022AbXKNCFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:05:21 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4763 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761484AbXKNCFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:19 -0500
Subject: [PATCH] - [7/15] - remove defconfig ptr comparisons to 0 - fs/lockd
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>, nfs@lists.sourceforge.net
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:05:18 -0800
Message-Id: <1195005918.5163.93.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/fs/lockd/svcshare.c b/fs/lockd/svcshare.c
index 068886d..98548ad 100644
--- a/fs/lockd/svcshare.c
+++ b/fs/lockd/svcshare.c
@@ -71,7 +71,7 @@ nlmsvc_unshare_file(struct nlm_host *host, struct nlm_file *file,
 	struct nlm_share	*share, **shpp;
 	struct xdr_netobj	*oh = &argp->lock.oh;
 
-	for (shpp = &file->f_shares; (share = *shpp) != 0; shpp = &share->s_next) {
+	for (shpp = &file->f_shares; (share = *shpp); shpp = &share->s_next) {
 		if (share->s_host == host && nlm_cmp_owner(share, oh)) {
 			*shpp = share->s_next;
 			kfree(share);


