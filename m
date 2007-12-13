Return-Path: <linux-kernel-owner+w=401wt.eu-S932951AbXLMUsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbXLMUsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764459AbXLMUsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:48:36 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45543 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764219AbXLMUsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:48:35 -0500
Date: Thu, 13 Dec 2007 12:48:30 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@woody.linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: SLUB: Remove useless masking of GFP_ZERO
Message-ID: <Pine.LNX.4.64.0712131246030.18254@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a recently added useless masking of GFP_ZERO. GFP_ZERO is 
already masked out in new_slab() (See how it calls allocate_slab). No need 
to do it twice. This reverts the SLUB parts of 
7fd272550bd43cc1d7289ef0ab2fa50de137e767.

Cc: Linus Torvalds <torvalds@woody.linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-12-13 12:41:34.000000000 -0800
+++ linux-2.6/mm/slub.c	2007-12-13 12:42:03.000000000 -0800
@@ -1468,9 +1468,6 @@ static void *__slab_alloc(struct kmem_ca
 	void **object;
 	struct page *new;
 
-	/* We handle __GFP_ZERO in the caller */
-	gfpflags &= ~__GFP_ZERO;
-
 	if (!c->page)
 		goto new_slab;
 
