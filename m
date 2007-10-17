Return-Path: <linux-kernel-owner+w=401wt.eu-S936488AbXJQDd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936488AbXJQDd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762378AbXJQDdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:33:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54422 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406AbXJQDdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:33:18 -0400
Date: Tue, 16 Oct 2007 20:33:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] document dma_flags_set/get_*()
Message-Id: <20071016203300.3f5bf599.akpm@linux-foundation.org>
In-Reply-To: <20071017014417.GL5601@sgi.com>
References: <20071017014417.GL5601@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 18:44:17 -0700 akepner@sgi.com wrote:

> @@ -547,3 +547,41 @@ size is the size (and should be a page-sized multiple).
>  The return value will be either a pointer to the processor virtual
>  address of the memory, or an error (via PTR_ERR()) if any part of the
>  region is occupied.
> +
> +int 
> +dma_flags_set_attr(u32 attr, enum dma_data_direction dir)
> +
> +Amend dir with a platform-specific "dma attribute".
> +
> +The only attribute currently defined is DMA_BARRIER_ATTR, which causes 
> +in-flight DMA to be flushed when the associated memory region is written 
> +to (see example below).  Setting DMA_BARRIER_ATTR provides a mechanism 
> +to enforce ordering of DMA on platforms that permit DMA to be reordered 
> +between device and host memory (within a NUMA interconnect).  On other 
> +platforms this is a nop.
> +
> +DMA_BARRIER_ATTR would be set when the memory region is mapped for DMA, 
> +e.g.:
> +
> +	int count;
> +	int flags = dma_flags_set_attr(DMA_BARRIER_ATTR, DMA_BIDIRECTIONAL);
> +	....
> +	count = dma_map_sg(dev, sglist, nents, flags);
> +

Isn't this rather a kludge?

What would be the cost of doing this cleanly and either redefining
dma_data_direction to be a field-of-bits or just leave dma_data_direction
alone (it is quite unrelated to this work, isn't it?) and adding new
fields/arguments to manage this new functionality?
