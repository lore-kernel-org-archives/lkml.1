Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbZFSEQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbZFSEQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 00:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbZFSEQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 00:16:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44812 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZFSEQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 00:16:24 -0400
Date: Fri, 19 Jun 2009 14:16:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: linux-next: slab tree build failure
Message-Id: <20090619141626.a60bba01.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

mm/slqb.c:75: error: 'SLAB_GFP_BOOT_MASK' undeclared here (not in a function)

Caused by commit df548b0bbaf2d4d16ce52d2f5ccdc1cfded70e06 ("SLQB: Fix
early boot allocations") from the slab tree interacting with commit
dcce284a259373f9e5570f2e33f79eca84fcf565 ("mm: Extend gfp masking to the
page allocator") that entered Linus' tree today.

I have applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 19 Jun 2009 14:13:21 +1000
Subject: [PATCH] slqb: fix for macro name change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/slqb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slqb.c b/mm/slqb.c
index b61ad01..4c9051d 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -72,7 +72,7 @@ static int slqb_min_objects = 1;
  * The slab allocator is initialized with interrupts disabled. Therefore, make
  * sure early boot allocations don't accidentally enable interrupts.
  */
-static gfp_t slab_gfp_mask __read_mostly = SLAB_GFP_BOOT_MASK;
+static gfp_t slab_gfp_mask __read_mostly = GFP_BOOT_MASK;
 
 #ifdef CONFIG_NUMA
 static inline int slab_numa(struct kmem_cache *s)
-- 
1.6.3.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
