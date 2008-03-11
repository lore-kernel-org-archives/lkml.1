Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbYCKRIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbYCKRIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYCKRIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:08:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:34738 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYCKRIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,481,1199692800"; 
   d="scan'208";a="217354694"
Subject: Re: [PATCH] pasemi_dma: Driver for PA Semi PWRficient on-chip
	DMAengine
From: Dan Williams <dan.j.williams@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>, linux-kernel@vger.kernel.org,
       pasemi-linux@ozlabs.org, linuxppc-dev@ozlabs.org, hskinnemoen@atmel.com
In-Reply-To: <20080306233900.GA3969@lixom.net>
References: <20080306233900.GA3969@lixom.net>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 10:04:11 -0700
Message-Id: <1205255051.26723.19.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-8.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 16:39 -0700, Olof Johansson wrote:
> pasemi_dma: Driver for PA Semi PWRficient on-chip DMA engine
>    
> First cut at a dma copy offload driver for PA Semi PWRficient. It uses the
> platform-specific functions to allocate channels, etc.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> 
> ---
> 
> This has some dependencies on other patches currently queued up in the
> powerpc git trees for 2.6.26. I'd appreciate reviews and acked-bys, but
> it might be easiest to just merge it up the powerpc path due to the
> dependencies.
> 
Apologies for not getting to this sooner.

I notice that the driver does not handle callbacks in its descriptor
cleanup path.  This could be ok if your intent is only to support the
net_dma style polled operations, but this will not work for the
raid-offload async_tx case.  I think the solution is for async_tx to
ignore channels without the DMA_INTERRUPT capability.

> +static void pasemi_dma_clean(struct pasemi_dma_chan *chan)
> +{
> +       int old, new, i;
> +       unsigned long flags;
> +       struct pasemi_dma_desc *desc;
> +       spin_lock_irqsave(&chan->desc_lock, flags);

Is spin_lock_bh() insufficient here?

...that's all that jumps out at the moment.

Regards,
Dan

