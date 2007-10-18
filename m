Return-Path: <linux-kernel-owner+w=401wt.eu-S1763316AbXJRArR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763316AbXJRArR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760512AbXJRArF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:47:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:23719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbXJRArC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:47:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,291,1188802800"; 
   d="scan'208";a="176987830"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/5] I/OAT: Add completion callback for async_tx interface use
Date: Wed, 17 Oct 2007 17:46:30 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C033FE9A3@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20071017173754.cdbe4363.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/5] I/OAT: Add completion callback for async_tx interface use
Thread-Index: AcgRHyEGf5YQCLXdThWcAomfxYoTwAAAIvcg
References: <20071018001416.31147.86176.stgit@localhost.localdomain><20071018001439.31147.52329.stgit@localhost.localdomain> <20071017173754.cdbe4363.akpm@linux-foundation.org>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>, <randy.dunlap@oracle.com>
X-OriginalArrivalTime: 18 Oct 2007 00:46:31.0528 (UTC) FILETIME=[535CDE80:01C81120]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Andrew Morton [mailto:akpm@linux-foundation.org] 
>
>On Wed, 17 Oct 2007 17:14:39 -0700
>Shannon Nelson <shannon.nelson@intel.com> wrote:
[...]
>> +static dma_async_tx_callback ioat_dma_test_callback(void 
>*dma_async_param)
>> +{
>> +	printk(KERN_ERR "ioatdma: ioat_dma_test_callback(0x%04llx)\n",
>> +		(u64)dma_async_param);
>> +	return 0;
>> +}
>
>This wanted to be `return NULL'.  I'll fix.

Thanks.

>
>>  /**
>>   * ioat_dma_self_test - Perform a IOAT transaction to 
>verify the HW works.
>>   * @device: device to be tested
>> @@ -691,6 +715,8 @@ static int ioat_dma_self_test(struct 
>ioatdma_device *device)
>>  	addr = dma_map_single(dma_chan->device->dev, dest, 
>IOAT_TEST_SIZE,
>>  			DMA_FROM_DEVICE);
>>  	ioat_set_dest(addr, tx, 0);
>> +	tx->callback = (void *)ioat_dma_test_callback;
>
>This cast is unneeded, surely?  It had better be..
>
>> +	tx->callback_param = (void *)0x8086;
>
>eh?

I suppose I could have used "42"...

sln
