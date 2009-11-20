Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbZKTHGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbZKTHGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 02:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbZKTHGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 02:06:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:61255 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbZKTHGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 02:06:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,776,1249282800"; 
   d="scan'208";a="213750496"
Subject: [PATCH 6/8] dmaengine: include xor/pq validate in
	device_has_all_tx_types()
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
Date: Fri, 20 Nov 2009 00:06:44 -0700
Message-ID: <20091120070644.13478.82384.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A channel must include these capabilities to satisfy
ASYNC_TX_DISABLE_CHANNEL_SWITCH.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/dmaengine.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index bd0b248..b6442f0 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -632,11 +632,15 @@ static bool device_has_all_tx_types(struct dma_device *device)
 	#if defined(CONFIG_ASYNC_XOR) || defined(CONFIG_ASYNC_XOR_MODULE)
 	if (!dma_has_cap(DMA_XOR, device->cap_mask))
 		return false;
+	if (!dma_has_cap(DMA_XOR_VAL, device->cap_mask))
+		return false;
 	#endif
 
 	#if defined(CONFIG_ASYNC_PQ) || defined(CONFIG_ASYNC_PQ_MODULE)
 	if (!dma_has_cap(DMA_PQ, device->cap_mask))
 		return false;
+	if (!dma_has_cap(DMA_PQ_VAL, device->cap_mask))
+		return false;
 	#endif
 
 	return true;

