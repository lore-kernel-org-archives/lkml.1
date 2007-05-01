Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbXEARFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbXEARFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbXEARFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:05:34 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:32303 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbXEARFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:05:32 -0400
Date: Tue, 1 May 2007 19:04:26 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Bill Irwin <bill.irwin@oracle.com>, linux-kernel@vger.kernel.org,
       bunk@stusta.de, akpm@osdl.org, gcoady@gmail.com, zlynx@acm.org,
       dgc@sgi.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       hch@infradead.org, jengelh@linux01.gwdg.de, zwane@infradead.org,
       neilb@suse.de, jens.axboe@oracle.com, eric@provenscaling.com
Subject: Re: [1/3] dynamically allocate IRQ stacks
Message-ID: <20070501170426.GA9376@osiris.ibm.com>
References: <20070430232351.GG26598@holomorphy.com> <20070430233309.GH26598@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430233309.GH26598@holomorphy.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void * __init __alloc_irqstack(int cpu)
> +{
> +	if (!cpu)
> +		return __alloc_bootmem(THREAD_SIZE, THREAD_SIZE,
> +						__pa(MAX_DMA_ADDRESS));
> +
> +	return (void *)__get_free_pages(GFP_KERNEL,
> +					ilog2(THREAD_SIZE/PAGE_SIZE));
> +}

I think you should test for slab_is_available() instead of checking
if the cpu number is 0.
