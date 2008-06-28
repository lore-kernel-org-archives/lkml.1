Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbYF1M3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbYF1M3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbYF1M3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:29:15 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49424 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbYF1M3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:29:14 -0400
Date: Sat, 28 Jun 2008 14:29:10 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       shannon.nelson@intel.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4 3/6] dmaengine: Add slave DMA interface
Message-ID: <20080628142910.320cea49@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jun 2008 12:28:58.0287 (UTC) FILETIME=[89B66BF0:01C8D91A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> + * @dma_dev: required DMA master device. If non-NULL, the client can not be
> + *	bound to other masters than this. The master driver may use
> + *	this to determine whether it's safe to access 

> +	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
> +		struct dma_chan *chan, struct scatterlist *sgl, 

Turns out I forgot to run checkpatch before posting. Here's a small
fixup. I'll fold it into this patch if I end up doing a v5 of this
series.

The unfinished comment above was redundant anyway, so I just removed
the last part.

 include/linux/dmaengine.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 8ce03e8..3d57439 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -131,8 +131,7 @@ typedef struct { DECLARE_BITMAP(bits, DMA_TX_TYPE_END); } dma_cap_mask_t;
  * struct dma_slave - Information about a DMA slave
  * @dev: device acting as DMA slave
  * @dma_dev: required DMA master device. If non-NULL, the client can not be
- *	bound to other masters than this. The master driver may use
- *	this to determine whether it's safe to access 
+ *	bound to other masters than this.
  * @tx_reg: physical address of data register used for
  *	memory-to-peripheral transfers
  * @rx_reg: physical address of data register used for
@@ -361,7 +360,7 @@ struct dma_device {
 		struct dma_chan *chan, unsigned long flags);
 
 	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
-		struct dma_chan *chan, struct scatterlist *sgl, 
+		struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_data_direction direction,
 		unsigned long flags);
 	void (*device_terminate_all)(struct dma_chan *chan);
-- 
1.5.5.4

