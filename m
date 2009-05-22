Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbZEVJcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbZEVJcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZEVJcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:32:08 -0400
Received: from ppp121-45-215-216.lns11.adl2.internode.on.net ([121.45.215.216]:51815
	"EHLO homer.shelbyville.oz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751022AbZEVJcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:32:08 -0400
X-Greylist: delayed 2460 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 May 2009 05:32:07 EDT
Date: Fri, 22 May 2009 18:20:40 +0930
From: Ron <ron@debian.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: cl@linux-foundation.org, mpm@selenic.com, linux-mm@kvack.org,
       akinobu.mita@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] slab: add missing guard for kernel_map_pages() use
Message-ID: <20090522085040.GC4448@homer.shelbyville.oz>
References: <20090521192822.GB4448@homer.shelbyville.oz> <1242979372.13681.1.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242979372.13681.1.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ron@debian.org
X-SA-Exim-Scanned: No (on homer.shelbyville.oz); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


All other uses of kernel_map_pages() are explicitly excluded without
CONFIG_DEBUG_PAGEALLOC, this one should be too.

Signed-off-by: Ron Lee <ron@debian.org>


diff --git a/mm/slab.c b/mm/slab.c
index 9a90b00..b5e5b27 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2674,10 +2683,12 @@ static void cache_init_objs(struct kmem_cache *cachep,
 				slab_error(cachep, "constructor overwrote the"
 					   " start of an object");
 		}
+#ifdef CONFIG_DEBUG_PAGEALLOC
 		if ((cachep->buffer_size % PAGE_SIZE) == 0 &&
 			    OFF_SLAB(cachep) && cachep->flags & SLAB_POISON)
 			kernel_map_pages(virt_to_page(objp),
 					 cachep->buffer_size / PAGE_SIZE, 0);
+#endif
 #else
 		if (cachep->ctor)
 			cachep->ctor(objp);


