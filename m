Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYLJKgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYLJKgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 05:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbYLJKgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 05:36:05 -0500
Received: from mail.gmx.net ([213.165.64.20]:52781 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755902AbYLJKgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 05:36:03 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+Pi+l0RWuPGylQdECE01xZiXazrXGUvmaqhe7nMu
	TO/QDcKeGaWcDd
Date: Wed, 10 Dec 2008 11:36:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/4 v2] dmaengine: add a tx_free method to struct
 dma_async_tx_descriptor
In-Reply-To: <Pine.LNX.4.64.0812101122250.4578@axis700.grange>
Message-ID: <Pine.LNX.4.64.0812101129340.4578@axis700.grange>
References: <Pine.LNX.4.64.0812101122250.4578@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <lg@denx.de>

Some users reuse DMA transaction descriptors multiple times and need an
explicit call to release them. An example of such a user is Video4Linux, which
has to be able to release descriptors on ioctl(VIDIOC_DQBUF).

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
 include/linux/dmaengine.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 64dea2a..58b2268 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -183,6 +183,7 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
  *	descriptors
  * @chan: target channel for this operation
  * @tx_submit: set the prepared descriptor(s) to be executed by the engine
+ * @tx_free: release a transaction descriptor
  * @callback: routine to call after this operation is complete
  * @callback_param: general parameter to pass to the callback routine
  * ---async_tx api specific fields---
@@ -197,6 +198,7 @@ struct dma_async_tx_descriptor {
 	struct list_head tx_list;
 	struct dma_chan *chan;
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
+	void (*tx_free)(struct dma_async_tx_descriptor *tx);
 	dma_async_tx_callback callback;
 	void *callback_param;
 	struct dma_async_tx_descriptor *next;
-- 
1.5.4

