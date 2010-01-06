Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247Ab0AFHZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0AFHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987Ab0AFHZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:25:26 -0500
Received: from mga10.intel.com ([192.55.52.92]:37095 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752166Ab0AFHZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:25:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,226,1262592000"; 
   d="scan'208";a="761726063"
Message-ID: <4B443AE3.2080800@linux.intel.com>
Date: Wed, 06 Jan 2010 15:25:23 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org
CC: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v3] slab: initialize unused alien cache entry as NULL at alloc_alien_cache().
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with existing code, it's a simpler way to use kzalloc_node()
to ensure that each unused alien cache entry is NULL.

CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
  mm/slab.c |    6 ++----
  1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 7dfa481..5d1a782 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -971,13 +971,11 @@ static struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)

  	if (limit > 1)
  		limit = 12;
-	ac_ptr = kmalloc_node(memsize, gfp, node);
+	ac_ptr = kzalloc_node(memsize, gfp, node);
  	if (ac_ptr) {
  		for_each_node(i) {
-			if (i == node || !node_online(i)) {
-				ac_ptr[i] = NULL;
+			if (i == node || !node_online(i))
  				continue;
-			}
  			ac_ptr[i] = alloc_arraycache(node, limit, 0xbaadf00d, gfp);
  			if (!ac_ptr[i]) {
  				for (i--; i >= 0; i--)
-- 
1.5.3.8


