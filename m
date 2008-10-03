Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYJCJ0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYJCJ0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYJCJ0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:26:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbYJCJ0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:26:44 -0400
Date: Fri, 3 Oct 2008 02:26:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: dan.j.williams@intel.com, maciej.sosnowski@intel.com,
       linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] dw_dmac: Fix copy/paste bug in tasklet
Message-Id: <20081003022638.788307fd.akpm@linux-foundation.org>
In-Reply-To: <1222784879-14160-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1222784879-14160-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 16:27:59 +0200 Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> The tasklet checks RAW.BLOCK twice, and does not check RAW.XFER. This is
> obviously wrong, and could theoretically cause the driver to hang.
> 
> Reported-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> ---
>  drivers/dma/dw_dmac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 94df917..0778d99 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -364,7 +364,7 @@ static void dw_dma_tasklet(unsigned long data)
>  	int i;
>  
>  	status_block = dma_readl(dw, RAW.BLOCK);
> -	status_xfer = dma_readl(dw, RAW.BLOCK);
> +	status_xfer = dma_readl(dw, RAW.XFER);
>  	status_err = dma_readl(dw, RAW.ERROR);
>  
>  	dev_vdbg(dw->dma.dev, "tasklet: status_block=%x status_err=%x\n",

We haven't heard from Dan for a week and this still wasn't in his tree
yesterday.

I think I'll cheerily send it in to Linus for 2.6.27.
