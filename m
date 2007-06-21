Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbXFUSvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbXFUSvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXFUSvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:51:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34257 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753317AbXFUSvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:51:10 -0400
Date: Thu, 21 Jun 2007 11:51:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: linux-kernel@vger.kernel.org
cc: mm-commits@vger.kernel.org
Subject: Re: + slub-faster-more-efficient-slab-determination-for-__kmalloc.patch
 added to -mm tree
In-Reply-To: <200706191919.l5JJJRh3019069@imap1.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706211149450.8284@schroedinger.engr.sgi.com>
References: <200706191919.l5JJJRh3019069@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The loop to disable slabs can use step 8. Looks a bit strange the way it 
is now.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm2/mm/slub.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/slub.c	2007-06-21 11:41:02.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/slub.c	2007-06-21 11:45:07.000000000 -0700
@@ -2606,7 +2606,7 @@ void __init kmem_cache_init(void)
 	BUG_ON(KMALLOC_MIN_SIZE > 256 ||
 		(KMALLOC_MIN_SIZE & (KMALLOC_MIN_SIZE - 1)));
 
-	for (i = 8; i < KMALLOC_MIN_SIZE;i++)
+	for (i = 8; i < KMALLOC_MIN_SIZE; i += 8)
 		size_index[(i - 1) / 8] = KMALLOC_SHIFT_LOW;
 
 	slab_state = UP;
