Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbXEDKm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbXEDKm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 06:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767788AbXEDKiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 06:38:50 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:3563 "EHLO
	amsfep14-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767810AbXEDKim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 06:38:42 -0400
Message-Id: <20070504103157.687590214@chello.nl>
References: <20070504102651.923946304@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 04 May 2007 12:27:01 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>, James Morris <jmorris@namei.org>
Subject: [PATCH 10/40] selinux: tag avc cache alloc as non-critical
Content-Disposition: inline; filename=mm-selinux-emergency.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Failing to allocate a cache entry will only harm performance not correctness.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: James Morris <jmorris@namei.org>
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

