Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbXI1Ddy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbXI1Ddy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 23:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbXI1Ddq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 23:33:46 -0400
Received: from colo.lackof.org ([198.49.126.79]:41097 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbXI1Ddp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 23:33:45 -0400
Date: Thu, 27 Sep 2007 21:33:26 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: akepner@sgi.com
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       RolandDreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [3/4] dma: document dma_flags_set_dmabarrier()
Message-ID: <20070928033326.GB14312@colo.lackof.org>
References: <20070928011302.GP30013@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928011302.GP30013@sgi.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 06:13:02PM -0700, akepner@sgi.com wrote:
> 
> Document dma_flags_set_dmabarrier().
> 
> Signed-off-by: Arthur Kepner <akepner@sgi.com>

This looks really good!

thanks,
grant

Acked-by: Grant Grundler <grundler@parisc-linux.org>

> 
> ---
>  DMA-API.txt |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+)
> 
> diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
> index cc7a8c3..5fc0bba 100644
> --- a/Documentation/DMA-API.txt
> +++ b/Documentation/DMA-API.txt
> @@ -544,3 +544,29 @@ size is the size (and should be a page-sized multiple).
>  The return value will be either a pointer to the processor virtual
>  address of the memory, or an error (via PTR_ERR()) if any part of the
>  region is occupied.
> +
> +int 
> +dma_flags_set_dmabarrier(int dir)
> +
> +Amend dir (one of the enum dma_data_direction values), with a 
> +platform-specific "dmabarrier" attribute.  The dmabarrier attribute 
> +forces a flush of all in-flight DMA when the associated memory 
> +region is written to (see example below.)
> +
> +This provides a mechanism to enforce ordering of DMA on platforms that 
> +permit DMA to be reordered between device and host memory (within a 
> +NUMA interconnect).  On other platforms this is a nop.
> +
> +The dmabarrier would be set when the memory region is mapped for DMA, 
> +e.g.:
> +
> +	int count, flags = dma_flags_set_dmabarrier(DMA_BIDIRECTIONAL);
> +	....
> +	count = dma_map_sg(dev, sglist, nents, flags);
> +
> +As an example of a situation where this would be useful, suppose that 
> +the device does a DMA write to indicate that data is ready and 
> +available in memory.  The DMA of the "completion indication" could 
> +race with data DMA.  Using a dmabarrier on the memory used for 
> +completion indications would prevent the race.
> +
