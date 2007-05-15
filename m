Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbXEOSxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbXEOSxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbXEOSxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:53:11 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:21982 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbXEOSxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:53:10 -0400
Date: Tue, 15 May 2007 19:52:49 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] slub: don't confuse ctor and dtor
Message-ID: <Pine.LNX.4.64.0705151951140.30826@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 15 May 2007 18:53:09.0681 (UTC) FILETIME=[480C8210:01C79722]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAA2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBjbGFtZXRlckBzZ2kuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kmem_cache_create() was swapping ctor and dtor in calling find_mergeable():
though it caused no bug, and probably never would, even if destructors are
retained; but fix it so as not to generate anxiety ;)

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.22-rc1/mm/slub.c	2007-05-13 05:41:01.000000000 +0100
+++ linux/mm/slub.c	2007-05-15 17:49:48.000000000 +0100
@@ -2522,7 +2522,7 @@ struct kmem_cache *kmem_cache_create(con
 	struct kmem_cache *s;
 
 	down_write(&slub_lock);
-	s = find_mergeable(size, align, flags, dtor, ctor);
+	s = find_mergeable(size, align, flags, ctor, dtor);
 	if (s) {
 		s->refcount++;
 		/*
