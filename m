Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbXEKPfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbXEKPfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 11:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbXEKPfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 11:35:24 -0400
Received: from ns.suse.de ([195.135.220.2]:43647 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409AbXEKPfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 11:35:23 -0400
Date: Fri, 11 May 2007 17:35:22 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix section mismatch
Message-ID: <20070511153521.GB22577@suse.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following compile warning:

--------- >8 --------
WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text
between 'kmem_cache_create' (at offset 0x2167b) and 'drain_alien_cache'

WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text
between 'kmem_cache_create' (at offset 0x216c1) and 'drain_alien_cache'
--------- 8< --------

set_up_list3s() can be called from setup_cpu_cache() [mm/slab.c] which is not
an init function.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
@@ -1960,7 +1960,7 @@ static void slab_destroy(struct kmem_cac
  * For setting up all the kmem_list3s for cache whose buffer_size is same as
  * size of kmem_list3.
  */
-static void __init set_up_list3s(struct kmem_cache *cachep, int index)
+static void set_up_list3s(struct kmem_cache *cachep, int index)
 {
 	int node;
 
