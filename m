Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbYB2JHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbYB2JHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 04:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYB2JHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 04:07:33 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49969 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbYB2JHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 04:07:31 -0500
Date: Fri, 29 Feb 2008 11:07:30 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: clameter@sgi.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] slub: look up object from the freelist once
Message-ID: <Pine.LNX.4.64.0802291105230.5423@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

We only need to look up object from c->page->freelist once in 
__slab_alloc().

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -1522,7 +1522,6 @@ load_freelist:
 	if (unlikely(SlabDebug(c->page)))
 		goto debug;
 
-	object = c->page->freelist;
 	c->freelist = object[c->offset];
 	c->page->inuse = s->objects;
 	c->page->freelist = c->page->end;
@@ -1578,7 +1577,6 @@ new_slab:
 
 	return NULL;
 debug:
-	object = c->page->freelist;
 	if (!alloc_debug_processing(s, c->page, object, addr))
 		goto another_slab;
 
