Return-Path: <linux-kernel-owner+w=401wt.eu-S933043AbXC3XJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbXC3XJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933056AbXC3XJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:09:31 -0400
Received: from mbox.ssc.unict.it ([151.97.230.9]:52877 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933043AbXC3XIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:08:55 -0400
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 3/3] slab: avoid __initdata warning (may be a bogus one)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Date: Sat, 31 Mar 2007 01:08:14 +0200
Message-ID: <20070330230814.19809.15981.stgit@americanbeauty.home.lan>
In-Reply-To: <20070330230746.19809.2000.stgit@americanbeauty.home.lan>
References: <20070330230746.19809.2000.stgit@americanbeauty.home.lan>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

set_up_list3s is not __init and references initkmem_list3.

Also, kmem_cache_create calls setup_cpu_cache which calls set_up_list3s. The
state machine _may_ prevent the code from accessing this data after freeing
initdata (it makes sure it's used only up to boot), so this warning may be a
false positive.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 mm/slab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 0934f8d..0772faf 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -305,7 +305,7 @@ struct kmem_list3 {
  * Need this for bootstrapping a per node allocator.
  */
 #define NUM_INIT_LISTS (2 * MAX_NUMNODES + 1)
-struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
+struct kmem_list3 initkmem_list3[NUM_INIT_LISTS];
 #define	CACHE_CACHE 0
 #define	SIZE_AC 1
 #define	SIZE_L3 (1 + MAX_NUMNODES)



