Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZGUIet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZGUIet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 04:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZGUIeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 04:34:46 -0400
Received: from mail.atmel.fr ([81.80.104.162]:40399 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZGUIep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 04:34:45 -0400
Message-ID: <4A657D58.2060708@atmel.com>
Date: Tue, 21 Jul 2009 10:33:28 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
CC: maciej.sosnowski@intel.com, avictor.za@gmail.com,
       patrice.vilchez@atmel.com
Subject: Re: [PATCH 1/2 v3] dmaengine: at_hdmac: new driver for the Atmel
 AHB 	DMA Controller
References: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>	 <1246641873-21686-1-git-send-email-nicolas.ferre@atmel.com> <e9c3a7c20907180901u3670a8edy2bc5c1b5cf911ab4@mail.gmail.com>
In-Reply-To: <e9c3a7c20907180901u3670a8edy2bc5c1b5cf911ab4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams :
> On Fri, Jul 3, 2009 at 10:24 AM, Nicolas Ferre<nicolas.ferre@atmel.com> wrote:
>> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is availlable on
>> at91sam9rl chip. It will be used on other products in the future.
>>
>> This first release covers only the memory-to-memory tranfer type. This is the
>> only tranfer type supported by this chip.  On other products, it will be used
>> also for peripheral DMA transfer (slave API support to come).
>>
>> I used dmatest client without problem in different configurations to test it.
>>
>> Full documentation for this controller can be found in the SAM9RL datasheet:
>> http://www.atmel.com/dyn/products/product_card.asp?part_id=4243
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>> v2 is here:
>> http://lkml.org/lkml/2009/6/26/104
>>
>> v2 -> v3:
>>  - initial number of descriptors to allocate for each channel raised to 64 and
>>   is now a parameter
>>  - ack-bit in descriptor flag comment synchronized with TXx9 dma driver
>>  - atc_desc_get() when short on descriptors in pool: create one at a time
>>  - allocation flag changed to GFP_ATOMIC in atc_desc_get()
>>  - call to proper funtion while unmapping: use of new
>>   DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE flags
>>  - call dma_run_dependencies() at the end of atc_chain_complete()
>>
> 
> Looks good, but now I belatedly wonder if that GFP_ATOMIC should be
> GFP_NOWAIT instead?  Do we really want to consume from the system
> emergency pools for these allocations (a similar fix is need for
> ioatdma and fsldma)?

Seems sensible indeed but I know little about allocation flags.

What do you think about including the driver and then building a patch
that fixes this flag in all allocation functions at a time.
It may add exposure to this modification and maybe encourage people to
react...

Regards,
-- 
Nicolas Ferre

