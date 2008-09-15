Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYIOHBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYIOHBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 03:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYIOHBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 03:01:42 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58184 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbYIOHBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 03:01:41 -0400
Date: Mon, 15 Sep 2008 10:01:39 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, sqazi@google.com
Subject: [GIT PULL] SLUB fixes for 2.6.27-rc6
Message-ID: <Pine.LNX.4.64.0809151001001.8963@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

The tree contains a small fix for SLUB /proc/slabinfo emulation from 
Salman Qazi.

                Pekka

Salman Qazi (1):
      slub: fixed uninitialized counter in struct kmem_cache_node

 mm/slub.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index fb486d5..0c83e6a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1932,6 +1932,7 @@ init_kmem_cache_node(struct kmem_cache_node *n, struct kmem_cache *s)
 	INIT_LIST_HEAD(&n->partial);
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_set(&n->nr_slabs, 0);
+	atomic_long_set(&n->total_objects, 0);
 	INIT_LIST_HEAD(&n->full);
 #endif
 }
