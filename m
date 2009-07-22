Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZGVNfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZGVNfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZGVNfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:35:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:24890 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbZGVNfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:35:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,247,1246863600"; 
   d="scan'208";a="477032194"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "avictor.za@gmail.com" <avictor.za@gmail.com>,
       "patrice.vilchez@atmel.com" <patrice.vilchez@atmel.com>
Date: Wed, 22 Jul 2009 14:35:06 +0100
Subject: RE: [PATCH 1/2 v3] dmaengine: at_hdmac: new driver for the Atmel
 AHB 	DMA Controller
Thread-Topic: [PATCH 1/2 v3] dmaengine: at_hdmac: new driver for the Atmel
 AHB 	DMA Controller
Thread-Index: AcoJ3iePonWDKRNUQU6muKrjWbMDmgA7X5oQ
Message-ID: <129600E5E5FB004392DDC3FB599660D7AF6D5C9A@irsmsx504.ger.corp.intel.com>
References: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
	 <1246641873-21686-1-git-send-email-nicolas.ferre@atmel.com>
 <e9c3a7c20907180901u3670a8edy2bc5c1b5cf911ab4@mail.gmail.com>
 <4A657D58.2060708@atmel.com>
In-Reply-To: <4A657D58.2060708@atmel.com>
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
> Dan Williams :
>> On Fri, Jul 3, 2009 at 10:24 AM, Nicolas Ferre<nicolas.ferre@atmel.com> wrote:
>>> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is availlable on
>>> at91sam9rl chip. It will be used on other products in the future.
>>> 
>>> This first release covers only the memory-to-memory tranfer type. This is the
>>> only tranfer type supported by this chip.  On other products, it will be used
>>> also for peripheral DMA transfer (slave API support to come).
>>> 
>>> I used dmatest client without problem in different configurations to test it.
>>> 
>>> Full documentation for this controller can be found in the SAM9RL datasheet:
>>> http://www.atmel.com/dyn/products/product_card.asp?part_id=4243
>>> 
>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com> ---
>>> v2 is here:
>>> http://lkml.org/lkml/2009/6/26/104
>>> 
>>> v2 -> v3:
>>>  - initial number of descriptors to allocate for each channel raised to 64 and   is now a
>>> parameter 
>>>  - ack-bit in descriptor flag comment synchronized with TXx9 dma driver
>>>  - atc_desc_get() when short on descriptors in pool: create one at a time
>>>  - allocation flag changed to GFP_ATOMIC in atc_desc_get()
>>>  - call to proper funtion while unmapping: use of new
>>>   DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE flags
>>>  - call dma_run_dependencies() at the end of atc_chain_complete()
>>> 
>> 
>> Looks good, but now I belatedly wonder if that GFP_ATOMIC should be
>> GFP_NOWAIT instead?  Do we really want to consume from the system
>> emergency pools for these allocations (a similar fix is need for
>> ioatdma and fsldma)?
> 
> Seems sensible indeed but I know little about allocation flags.
> 
> What do you think about including the driver and then building a patch
> that fixes this flag in all allocation functions at a time.
> It may add exposure to this modification and maybe encourage people to
> react...

I think it's a good plan.
I will prepare similar patch on allocation flags for ioatdma.

For this v3 patch:

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>

Regards,
Maciej