Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbXJ3QZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbXJ3QZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbXJ3QQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:16:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbXJ3QNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:13:39 -0400
Message-Id: <20071030160913.027906000@chello.nl>
References: <20071030160401.296770000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 30 Oct 2007 17:04:13 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, James Morris <jmorris@namei.org>
Subject: [PATCH 12/33] selinux: tag avc cache alloc as non-critical
Content-Disposition: inline; filename=mm-selinux-emergency.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Failing to allocate a cache entry will only harm performance not correctness.
Do not consume valuable reserve pages for something like that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: James Morris <jmorris@namei.org>
---
 security/selinux/avc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-2/security/selinux/avc.c
===================================================================
--- linux-2.6-2.orig/security/selinux/avc.c
+++ linux-2.6-2/security/selinux/avc.c
@@ -334,7 +334,7 @@ static struct avc_node *avc_alloc_node(v
 {
 	struct avc_node *node;
 
-	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC);
+	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC|__GFP_NOMEMALLOC);
 	if (!node)
 		goto out;
 

--

