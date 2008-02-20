Return-Path: <linux-kernel-owner+w=401wt.eu-S1765054AbYBTPV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765054AbYBTPV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764119AbYBTPTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:19:17 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:61526 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbYBTPSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:18:37 -0500
Message-Id: <20080220150306.682229000@chello.nl>
References: <20080220144610.548202000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 20 Feb 2008 15:46:21 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, James Morris <jmorris@namei.org>
Subject: [PATCH 11/28] selinux: tag avc cache alloc as non-critical
Content-Disposition: inline; filename=mm-selinux-emergency.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Failing to allocate a cache entry will only harm performance not correctness.
Do not consume valuable reserve pages for something like that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: James Morris <jmorris@namei.org>
---
 security/selinux/avc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/security/selinux/avc.c
===================================================================
--- linux-2.6.orig/security/selinux/avc.c
+++ linux-2.6/security/selinux/avc.c
@@ -334,7 +334,7 @@ static struct avc_node *avc_alloc_node(v
 {
 	struct avc_node *node;
 
-	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC);
+	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC|__GFP_NOMEMALLOC);
 	if (!node)
 		goto out;
 

--

