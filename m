Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYKGL6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYKGL6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYKGL6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:58:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:62965 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbYKGL6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:58:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,564,1220252400"; 
   d="scan'208";a="357311790"
From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH 3/4] I/OAT: fix async_tx.callback checking
To: dan.j.williams@intel.com
Cc: tom.s.picard@intel.com, mark_rustad@Xiotech.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org
Date: Fri, 07 Nov 2008 12:46:55 +0100
Message-ID: <20081107114642.25190.49701.stgit@linux.site>
In-Reply-To: <20081107114325.25190.5419.stgit@linux.site>
References: <20081107114325.25190.5419.stgit@linux.site>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Sosnowski <maciej.sosnowski@intel.com>

async_tx.callback should be checked for the first
not the last descriptor in the chain.

Cc: <stable@kernel.org>
Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
---

 drivers/dma/ioat_dma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 687eef7..c5af17a 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -525,7 +525,7 @@ static dma_cookie_t ioat1_tx_submit(stru
 	}
 
 	hw->ctl = IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
-	if (new->async_tx.callback) {
+	if (first->async_tx.callback) {
 		hw->ctl |= IOAT_DMA_DESCRIPTOR_CTL_INT_GN;
 		if (first != new) {
 			/* move callback into to last desc */
@@ -617,7 +617,7 @@ static dma_cookie_t ioat2_tx_submit(stru
 	}
 
 	hw->ctl |= IOAT_DMA_DESCRIPTOR_CTL_CP_STS;
-	if (new->async_tx.callback) {
+	if (first->async_tx.callback) {
 		hw->ctl |= IOAT_DMA_DESCRIPTOR_CTL_INT_GN;
 		if (first != new) {
 			/* move callback into to last desc */

