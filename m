Return-Path: <linux-kernel-owner+w=401wt.eu-S936560AbXJQD3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936560AbXJQD3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936466AbXJQD31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:29:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44377 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936457AbXJQD30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:29:26 -0400
Date: Tue, 16 Oct 2007 20:29:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dma: redefine dma_flags_set/get_*() for sn-ia64
Message-Id: <20071016202904.8e9d505b.akpm@linux-foundation.org>
In-Reply-To: <20071017014316.GK5601@sgi.com>
References: <20071017014316.GK5601@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 18:43:16 -0700 akepner@sgi.com wrote:

> @@ -153,7 +153,7 @@ EXPORT_SYMBOL(sn_dma_free_coherent);
>   * @dev: device to map for
>   * @cpu_addr: kernel virtual address of the region to map
>   * @size: size of the region
> - * @direction: DMA direction
> + * @flags: DMA direction, and arch-specific attributes
>   *
>   * Map the region pointed to by @cpu_addr for DMA and return the
>   * DMA address.
> @@ -167,17 +167,23 @@ EXPORT_SYMBOL(sn_dma_free_coherent);
>   *       figure out how to save dmamap handle so can use two step.
>   */
>  dma_addr_t sn_dma_map_single(struct device *dev, void *cpu_addr, size_t size,
> -			     int direction)
> +			     int flags)
>  {
>  	dma_addr_t dma_addr;
>  	unsigned long phys_addr;
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
> +	int dmabarrier = dma_flags_get_attr(flags) & DMA_BARRIER_ATTR;

So we take an `enum data_direction' and then wedge it into a word alongside
some extra flags?

Can we do something nicer than that?
