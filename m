Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbZGCM7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbZGCM7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZGCM7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:59:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:48292 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbZGCM7Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:59:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,341,1243839600"; 
   d="scan'208";a="427384455"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "avictor.za@gmail.com" <avictor.za@gmail.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "patrice.vilchez@atmel.com" <patrice.vilchez@atmel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 3 Jul 2009 13:59:24 +0100
Subject: RE: [PATCH 1/2 v2] dmaengine: at_hdmac: new driver for the Atmel
 AHB DMA Controller
Thread-Topic: [PATCH 1/2 v2] dmaengine: at_hdmac: new driver for the Atmel
 AHB DMA Controller
Thread-Index: Acn2QjYRtL6O+2BQRDW0U/GDUoc9PAFmpSAQ
Message-ID: <129600E5E5FB004392DDC3FB599660D7AF555E87@irsmsx504.ger.corp.intel.com>
References: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is availlable on
> at91sam9rl chip. It will be used on other products in the future.
> 
> This first release covers only the memory-to-memory tranfer type. This is the
> only tranfer type supported by this chip.  On other products, it will be used
> also for peripheral DMA transfer (slave API support to come).
> 
> I used dmatest client without problem in different configurations to test it.
> 
> Full documentation for this controller can be found in the SAM9RL datasheet:
> http://www.atmel.com/dyn/products/product_card.asp?part_id=4243
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
[...]
> +	/*
> +	 * We use dma_unmap_page() regardless of how the buffers were
> +	 * mapped before they were submitted...
> +	 */
> +	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP))
> +		dma_unmap_page(chan2parent(&atchan->chan_common), desc->lli.daddr,
> +				desc->len, DMA_FROM_DEVICE);
> +	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP))
> +		dma_unmap_page(chan2parent(&atchan->chan_common), desc->lli.saddr,
> +				desc->len, DMA_TO_DEVICE);

It is similar issue as the one fixed in 2.6.30 by 'ioatdma: fix "ioatdma frees DMA memory with wrong function"' patch:
commit 4f005dbe5584fe54c9f6d6d4f0acd3fb29be84da.
Note that this patch introduces dma control flags: DMA_COMPL_SRC_UNMAP_SINGLE and DMA_COMPL_DEST_UNMAP_SINGLE,
that could be used by the driver to choose proper unmapping.

Regards,
Maciej