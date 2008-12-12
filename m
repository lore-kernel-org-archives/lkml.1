Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbYLLQti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbYLLQti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbYLLQsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:48:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:37309 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758746AbYLLQsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:48:50 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/mbiYO2q3mDrseVFrFyjDyMdDv7LvSz4dHmrxkZt
	mZKKHhFmJl7IyM
Date: Fri, 12 Dec 2008 17:49:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/4 v3] dmaengine: add async_tx_clear_ack() macro
In-Reply-To: <Pine.LNX.4.64.0812121740240.6411@axis700.grange>
Message-ID: <Pine.LNX.4.64.0812121744230.6411@axis700.grange>
References: <Pine.LNX.4.64.0812121740240.6411@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <lg@denx.de>

To complete the DMA_CTRL_ACK handling API add a async_tx_clear_ack() macro.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
 include/linux/dmaengine.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 64dea2a..c820a3f 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -287,6 +287,11 @@ static inline void async_tx_ack(struct dma_async_tx_descriptor *tx)
 	tx->flags |= DMA_CTRL_ACK;
 }
 
+static inline void async_tx_clear_ack(struct dma_async_tx_descriptor *tx)
+{
+	tx->flags &= ~DMA_CTRL_ACK;
+}
+
 static inline bool async_tx_test_ack(struct dma_async_tx_descriptor *tx)
 {
 	return (tx->flags & DMA_CTRL_ACK) == DMA_CTRL_ACK;
-- 
1.5.4

