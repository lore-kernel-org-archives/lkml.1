Return-Path: <linux-kernel-owner+w=401wt.eu-S1751316AbXBUPFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbXBUPFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXBUPFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:05:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34537 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbXBUPFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:05:35 -0500
Message-Id: <20070221144842.396545000@taijtu.programming.kicks-ass.net>
References: <20070221144304.512721000@taijtu.programming.kicks-ass.net>
User-Agent: quilt/0.46-1
Date: Wed, 21 Feb 2007 15:43:13 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Subject: [PATCH 09/29] selinux: tag avc cache alloc as non-critical
Content-Disposition: inline; filename=mm-selinux-emergency.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Failing to allocate a cache entry will only harm performance.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 security/selinux/avc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-git/security/selinux/avc.c
===================================================================
--- linux-2.6-git.orig/security/selinux/avc.c	2007-02-14 08:31:13.000000000 +0100
+++ linux-2.6-git/security/selinux/avc.c	2007-02-14 10:10:47.000000000 +0100
@@ -332,7 +332,7 @@ static struct avc_node *avc_alloc_node(v
 {
 	struct avc_node *node;
 
-	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC);
+	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC|__GFP_NOMEMALLOC);
 	if (!node)
 		goto out;
 

-- 

