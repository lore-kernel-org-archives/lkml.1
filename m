Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYJCJdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYJCJdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYJCJdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:33:03 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:27410 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753457AbYJCJdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:33:01 -0400
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 08/32] mm: slb: add knowledge of reserve pages
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>,
       David Miller <davem@davemloft.net>
In-Reply-To: <20081002131608.091390019@chello.nl>
References: <20081002130504.927878499@chello.nl>
	 <20081002131608.091390019@chello.nl>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 11:32:38 +0200
Message-Id: <1223026358.28938.2.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because I'm a dork and forgot to refresh...

---
Index: linux-2.6/mm/slob.c
===================================================================
--- linux-2.6.orig/mm/slob.c
+++ linux-2.6/mm/slob.c
@@ -239,7 +239,7 @@ static int slob_last(slob_t *s)
 
 static void *slob_new_page(gfp_t gfp, int order, int node)
 {
-	void *page;
+	struct page *page;
 
 #ifdef CONFIG_NUMA
 	if (node != -1)
@@ -318,7 +318,7 @@ static void *slob_alloc(size_t size, gfp
 	slob_t *b = NULL;
 	unsigned long flags;
 
-	if (unlikely(slub_reserve)) {
+	if (unlikely(slob_reserve)) {
 		if (!(gfp_to_alloc_flags(gfp) & ALLOC_NO_WATERMARKS))
 			goto grow;
 	}


