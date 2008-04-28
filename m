Return-Path: <linux-kernel-owner+w=401wt.eu-S965589AbYD1Psi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965589AbYD1Psi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964991AbYD1Pkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:40:31 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49172 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935649AbYD1Pk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:40:28 -0400
Date: Mon, 28 Apr 2008 18:39:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make nfs4_drop_state_owner() static
Message-ID: <20080428153955.GS2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nfs4_drop_state_owner() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/nfs/nfs4_fs.h   |    1 -
 fs/nfs/nfs4state.c |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

c13c9c023ace63d07e04e85ed60bab169abbeabc diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index bd1b9d6..ea79064 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -206,7 +206,6 @@ struct rpc_cred *nfs4_get_renew_cred(struct nfs_client *clp);
 
 extern struct nfs4_state_owner * nfs4_get_state_owner(struct nfs_server *, struct rpc_cred *);
 extern void nfs4_put_state_owner(struct nfs4_state_owner *);
-extern void nfs4_drop_state_owner(struct nfs4_state_owner *);
 extern struct nfs4_state * nfs4_get_open_state(struct inode *, struct nfs4_state_owner *);
 extern void nfs4_put_open_state(struct nfs4_state *);
 extern void nfs4_close_state(struct path *, struct nfs4_state *, mode_t);
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 46eb624..da76c2e 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -282,7 +282,7 @@ nfs4_alloc_state_owner(void)
 	return sp;
 }
 
-void
+static void
 nfs4_drop_state_owner(struct nfs4_state_owner *sp)
 {
 	if (!RB_EMPTY_NODE(&sp->so_client_node)) {

