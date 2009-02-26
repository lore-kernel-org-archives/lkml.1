Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZBZKPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZBZKPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZBZKOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:14:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:19569 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbZBZKON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:14:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,270,1233561600"; 
   d="scan'208";a="434322932"
From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH 6/7] I/OAT: list usage cleanup
To: dan.j.williams@intel.com
Cc: snakebyte@gmx.de, shannon.nelson@intel.com, jeffrey.t.krisher@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 26 Feb 2009 11:05:30 +0100
Message-ID: <20090226100525.3615.38859.stgit@linux.site>
In-Reply-To: <20090226100327.3615.21419.stgit@linux.site>
References: <20090226100327.3615.21419.stgit@linux.site>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sesterhenn <snakebyte@gmx.de>

Trivial cleanup, list_del(); list_add_tail() is equivalent
to list_move_tail(). Semantic patch for coccinelle can be
found at www.cccmz.de/~snakebyte/list_move_tail.spatch

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Acked-by: Jeff Kirsher <jeffrey.t.krisher@intel.com>
---

 drivers/dma/ioat_dma.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index fc9b845..ae8c0ce 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -1171,9 +1171,8 @@ #endif
 				 * up if the client is done with the descriptor
 				 */
 				if (async_tx_test_ack(&desc->async_tx)) {
-					list_del(&desc->node);
-					list_add_tail(&desc->node,
-						      &ioat_chan->free_desc);
+					list_move_tail(&desc->node,
+						       &ioat_chan->free_desc);
 				} else
 					desc->async_tx.cookie = 0;
 			} else {

