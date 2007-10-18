Return-Path: <linux-kernel-owner+w=401wt.eu-S1765093AbXJRKyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765093AbXJRKyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763237AbXJRKwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:52:44 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44772 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764959AbXJRKwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:52:43 -0400
Date: Thu, 18 Oct 2007 12:53:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Tom Talpey <talpey@netapp.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] sunrpc/xprtrdma/transport.c: fix use-after-free
Message-ID: <20071018105312.GO3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an obvious use-after-free spotted by the Coverity 
checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
9bb1151172d05c2ffdb09302eb82ca6e1edae47d 
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index dc55cc9..1afeb3e 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -320,9 +320,9 @@ xprt_setup_rdma(struct xprt_create *args)
 	xprt->slot = kcalloc(xprt->max_reqs,
 				sizeof(struct rpc_rqst), GFP_KERNEL);
 	if (xprt->slot == NULL) {
-		kfree(xprt);
 		dprintk("RPC:       %s: couldn't allocate %d slots\n",
 			__func__, xprt->max_reqs);
+		kfree(xprt);
 		return ERR_PTR(-ENOMEM);
 	}
 

