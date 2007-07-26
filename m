Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbXGZQfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbXGZQfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764114AbXGZQdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:33:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35223 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933981AbXGZQdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:33:50 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] lockd and nfsd endianness annotation fixes
Cc: linux-kernel@vger.kernel.org, neilb@suse.de
Message-Id: <E1IE6Hd-0005Dl-Hu@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:33:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/lockd/svclock.c |    6 +++---
 fs/nfsd/nfs4xdr.c  |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index b3efa45..a21e4bc 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -335,10 +335,10 @@ static void nlmsvc_freegrantargs(struct nlm_rqst *call)
 /*
  * Deferred lock request handling for non-blocking lock
  */
-static u32
+static __be32
 nlmsvc_defer_lock_rqst(struct svc_rqst *rqstp, struct nlm_block *block)
 {
-	u32 status = nlm_lck_denied_nolocks;
+	__be32 status = nlm_lck_denied_nolocks;
 
 	block->b_flags |= B_QUEUED;
 
@@ -352,7 +352,7 @@ nlmsvc_defer_lock_rqst(struct svc_rqst *rqstp, struct nlm_block *block)
 			status = nlm_drop_reply;
 	}
 	dprintk("lockd: nlmsvc_defer_lock_rqst block %p flags %d status %d\n",
-		block, block->b_flags, status);
+		block, block->b_flags, ntohl(status));
 
 	return status;
 }
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b3d55c6..8ef0964 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2450,7 +2450,7 @@ nfsd4_encode_rename(struct nfsd4_compoundres *resp, __be32 nfserr, struct nfsd4_
 }
 
 static void
-nfsd4_encode_secinfo(struct nfsd4_compoundres *resp, int nfserr,
+nfsd4_encode_secinfo(struct nfsd4_compoundres *resp, __be32 nfserr,
 		     struct nfsd4_secinfo *secinfo)
 {
 	int i = 0;
-- 
1.5.3.GIT

