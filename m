Return-Path: <linux-kernel-owner+w=401wt.eu-S965025AbXIGIoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025AbXIGIoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 04:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965091AbXIGInn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 04:43:43 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4673 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965072AbXIGInl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 04:43:41 -0400
Date: Fri, 7 Sep 2007 09:43:22 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] [RFC] IOAT: Add support for version 2 of ioatdma device
Message-ID: <20070907084322.GA10837@shadowen.org>
References: <20070906170712.7444.34573.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906170712.7444.34573.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 10:07:12AM -0700, Shannon Nelson wrote:
>  	list_for_each_entry(iter, &desc->async_tx.tx_list, node) {
>  		iter->hw->src_addr = addr;
>  		addr += ioat_chan->xfercap;
> +
> +		if (--cnt == 0);
> +			break;
>  	}
>  
>  }
> @@ -166,20 +177,28 @@ static void ioat_set_dest(dma_addr_t addr,
>  {
>  	struct ioat_desc_sw *iter, *desc = tx_to_ioat_desc(tx);
>  	struct ioat_dma_chan *ioat_chan = to_ioat_chan(tx->chan);
> +	int cnt = desc->tx_cnt;
>  
>  	pci_unmap_addr_set(desc, dst, addr);
>  
>  	list_for_each_entry(iter, &desc->async_tx.tx_list, node) {
>  		iter->hw->dst_addr = addr;
>  		addr += ioat_chan->xfercap;
> +
> +		if (--cnt == 0);
> +			break;
>  	}

Those two look suspect to checkpatch, and I have to agree with it.

WARNING: Trailing semicolon indicates no statements, indent implies
otherwise
#346: FILE: drivers/dma/ioat_dma.c:168:
+               if (--cnt == 0);
+                       break;
WARNING: Trailing semicolon indicates no statements, indent implies
otherwise
#363: FILE: drivers/dma/ioat_dma.c:188:
+               if (--cnt == 0);
+                       break;

-apw
