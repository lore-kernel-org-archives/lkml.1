Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYCOAQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYCOAQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 20:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYCOAQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 20:16:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49220 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751291AbYCOAQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 20:16:25 -0400
Date: Fri, 14 Mar 2008 17:15:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
In-Reply-To: <Pine.LNX.4.64.0803141356540.28115@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0803141713340.29413@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>  <20080313014808.f8d25c2a.akpm@linux-foundation.org>
  <1205400538.3215.148.camel@ymzhang>  <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
  <1205463842.3215.188.camel@ymzhang>  <Pine.LNX.4.64.0803132328330.24204@schroedinger.engr.sgi.com>
 <1205478861.3215.279.camel@ymzhang> <Pine.LNX.4.64.0803141356540.28115@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch to just not perform refills but switch slabs instead. 
Could check what effect doing so has on the statistics you see on the 16p?

---
 mm/slub.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-03-14 16:49:36.000000000 -0700
+++ linux-2.6/mm/slub.c	2008-03-14 16:50:04.000000000 -0700
@@ -1474,10 +1474,7 @@ static void *__slab_alloc(struct kmem_ca
 		goto new_slab;
 
 	slab_lock(c->page);
-	if (unlikely(!node_match(c, node)))
-		goto another_slab;
-
-	stat(c, ALLOC_REFILL);
+	goto another_slab;
 
 load_freelist:
 	object = c->page->freelist;
