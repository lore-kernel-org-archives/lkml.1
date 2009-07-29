Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZG2NFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZG2NFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbZG2NFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:05:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:11458 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbZG2NFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:05:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,289,1246863600"; 
   d="scan'208";a="434347025"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: "haavard.skinnemoen@atmel.com" <haavard.skinnemoen@atmel.com>,
       "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "patrice.vilchez@atmel.com" <patrice.vilchez@atmel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 29 Jul 2009 14:05:17 +0100
Subject: RE: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
Thread-Topic: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
Thread-Index: AcoPlrB2OVJlFtg6T0anADmiK4wqGwAtFdKg
Message-ID: <129600E5E5FB004392DDC3FB599660D7B2980817@irsmsx504.ger.corp.intel.com>
References: <20090724.222919.240484146.anemo@mba.ocn.ne.jp>
	<20090724161001.412e0199@siona>
	<129600E5E5FB004392DDC3FB599660D7B271F468@irsmsx504.ger.corp.intel.com>
 <20090729.001330.172537373.anemo@mba.ocn.ne.jp>
In-Reply-To: <20090729.001330.172537373.anemo@mba.ocn.ne.jp>
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

Atsushi Nemoto wrote:
> On Mon, 27 Jul 2009 14:24:26 +0100, "Sosnowski, Maciej" <maciej.sosnowski@intel.com> wrote:
>>>> Your atc_chain_complete() calls dma_unmap_xxx unless
>>>> DMA_COMPL_SKIP_XXX_UNMAP specified.  But atmel-mci driver does not set
>>>> the flag on dma_async_tx_descriptor.  I suppose one of them should be
>>>> fixed.
>>> 
>>> atmel-mci should definitely set that flag.
>>> 
>>> Haavard
>> 
>> I agree with Haavard.
> 
> Then, what should dma driver do when client driver did not set these
> flags?  If it should call dma_unmap_sg(), the dma driver should keep
> sg and direction somewhere...

Well, what about BUG_ON?

> 
> Also, calling dma_map_sg() in its prep_slave_sg function will not fit
> for sound drivers, which use DMA buffers prepared in its framework.

It looks like a need for one more flag: DMA_SKIP_MAP_SG.
What do you think?

Regards,
Maciej
