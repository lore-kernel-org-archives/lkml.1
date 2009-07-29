Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbZG2O2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbZG2O2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZG2O2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:28:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:58869 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbZG2O2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:28:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,289,1246863600"; 
   d="scan'208";a="170145426"
Message-ID: <4A705C6F.1000203@intel.com>
Date: Wed, 29 Jul 2009 07:27:59 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       "haavard.skinnemoen@atmel.com" <haavard.skinnemoen@atmel.com>,
       "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "patrice.vilchez@atmel.com" <patrice.vilchez@atmel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
References: <20090724.222919.240484146.anemo@mba.ocn.ne.jp>	<20090724161001.412e0199@siona>	<129600E5E5FB004392DDC3FB599660D7B271F468@irsmsx504.ger.corp.intel.com> <20090729.001330.172537373.anemo@mba.ocn.ne.jp>
In-Reply-To: <20090729.001330.172537373.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> On Mon, 27 Jul 2009 14:24:26 +0100, "Sosnowski, Maciej" <maciej.sosnowski@intel.com> wrote:
>>>> Your atc_chain_complete() calls dma_unmap_xxx unless
>>>> DMA_COMPL_SKIP_XXX_UNMAP specified.  But atmel-mci driver does not set
>>>> the flag on dma_async_tx_descriptor.  I suppose one of them should be
>>>> fixed.
>>> atmel-mci should definitely set that flag.
>>>
>>> Haavard
>> I agree with Haavard.
> 
> Then, what should dma driver do when client driver did not set these
> flags?  If it should call dma_unmap_sg(), the dma driver should keep
> sg and direction somewhere...
> 
> Also, calling dma_map_sg() in its prep_slave_sg function will not fit
> for sound drivers, which use DMA buffers prepared in its framework.
> 
> For slave DMA, doing all mapping/unmapping in DMA client is better,
> isn't it?
> 

Yes it is.  The whole point of the dma driver doing its own unmapping is 
specifically for clients that use the async_tx api, i.e. where they do 
not know if the transaction is carried out in hardware and have no way 
of tracking the details necessary to perform the unmap.  DMA-slave 
clients request specific channels and know the hardware details at a low 
level, so it should not be too high an expectation to push dma mapping 
responsibility to the client.

--
Dan
