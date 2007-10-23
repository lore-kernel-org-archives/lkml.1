Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbXJWEPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbXJWEPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXJWEOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:14:49 -0400
Received: from lixom.net ([66.141.50.11]:56954 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbXJWEOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:14:49 -0400
Date: Mon, 22 Oct 2007 23:21:53 -0500
From: Olof Johansson <olof@lixom.net>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: [PATCH] Fix warning in mm/slub.c
Message-ID: <20071023042153.GA20693@lixom.net>
References: <20071018122345.514F.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018122345.514F.Y-GOTO@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Make kmem_cache_node for SLUB on memory online to avoid panic" introduced
the following:

mm/slub.c:2737: warning: passing argument 1 of 'atomic_read' from
incompatible pointer type


Signed-off-by: Olof Johansson <olof@lixom.net>


diff --git a/mm/slub.c b/mm/slub.c
index aac1dd3..bcdb2c8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2734,7 +2734,7 @@ static void slab_mem_offline_callback(void *arg)
 			 * and offline_pages() function shoudn't call this
 			 * callback. So, we must fail.
 			 */
-			BUG_ON(atomic_read(&n->nr_slabs));
+			BUG_ON(atomic_long_read(&n->nr_slabs));
 
 			s->node[offline_node] = NULL;
 			kmem_cache_free(kmalloc_caches, n);
