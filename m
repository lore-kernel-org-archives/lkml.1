Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbYHYHcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbYHYHcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 03:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYHYHcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 03:32:13 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43000 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYHYHcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 03:32:12 -0400
Date: Mon, 25 Aug 2008 10:32:10 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
Subject: [GIT PULL] SLUB fixes for 2.6.27-rc4
Message-ID: <Pine.LNX.4.64.0808251030310.32731@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

Changes:

  - Fix for excessive memory use by SLUB on NUMA when running 
    hackbench (Christoph Lameter)

                Pekka

Christoph Lameter (1):
      slub: Disable NUMA remote node defragmentation by default

 mm/slub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4f5b961..fb486d5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2312,7 +2312,7 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 
 	s->refcount = 1;
 #ifdef CONFIG_NUMA
-	s->remote_node_defrag_ratio = 100;
+	s->remote_node_defrag_ratio = 1000;
 #endif
 	if (!init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
 		goto error;
@@ -4058,7 +4058,7 @@ static ssize_t remote_node_defrag_ratio_store(struct kmem_cache *s,
 	if (err)
 		return err;
 
-	if (ratio < 100)
+	if (ratio <= 100)
 		s->remote_node_defrag_ratio = ratio * 10;
 
 	return length;
