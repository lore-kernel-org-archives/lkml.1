Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbXGISxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbXGISxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXGISxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:53:31 -0400
Received: from gherkin.frus.com ([192.158.254.49]:60276 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312AbXGISxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:53:30 -0400
Subject: Re: 2.6.22-rc6 bad page error
In-Reply-To: <Pine.LNX.4.64.0707071852240.12481@blonde.wat.veritas.com>
 "from Hugh Dickins at Jul 7, 2007 07:38:58 pm"
To: Hugh Dickins <hugh@veritas.com>
Date: Mon, 9 Jul 2007 13:53:24 -0500 (CDT)
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070709185324.387ACDBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> (...) I'm expecting this to be a regression we introduced in
> 2.6.15, rather than recently in 2.6.22 (now, that's better isn't it ;-?)
> (...)
> I think sound/isa/es18xx.c's
> 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
> will take it to sound/core/memalloc.c's
> 	res = dma_alloc_coherent(dev, PAGE_SIZE << pg, dma, gfp_flags);
> where we've carefully included __GFP_COMP in gfp_flags to avoid this
> kind of problem (replacing the pre-2.6.15 use of PageReserved).
> (...)
> Blame me or Nick for removing the
> special PageReserved usage, or Alpha for ignoring our gfp_flags:
> 
>   #define dma_alloc_coherent(dev, size, addr, gfp)	\
> 		pci_alloc_consistent(alpha_gendev_to_pci(dev), size, addr)
> 
> When you get a chance, please would you try patch below?
> 
> --- 2.6.22-rc7/arch/alpha/kernel/pci_iommu.c	2007-06-05 06:19:19.000000000 +0100
> +++ linux/arch/alpha/kernel/pci_iommu.c	2007-07-07 15:00:04.000000000 +0100

That seems to have done the trick.  Normally, I get the "bad page"
errors on the second NX session, but I'm on the third session of the
day (thus far), and everything seems to be ok as far as I can tell.

-- 
-----------------------------------------------------------------------
Bob Tracy               | "Eagles may soar, but weasels don't get
rct@frus.com            |  sucked into jet engines."       --Anon
-----------------------------------------------------------------------
