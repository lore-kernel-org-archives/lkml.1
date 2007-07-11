Return-Path: <linux-kernel-owner+w=401wt.eu-S1765951AbXGKSCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765951AbXGKSCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbXGKSCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:02:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:59794 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757598AbXGKSCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:02:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,527,1175497200"; 
   d="scan'208";a="249189807"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][PATCH] DMA: Expand dmaengine implementation for more DMACs
Date: Wed, 11 Jul 2007 11:02:15 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02A878CB@orsmsx418.amr.corp.intel.com>
In-Reply-To: <e9c3a7c20707110943w5539167ei41f6d1928d1b33a6@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH] DMA: Expand dmaengine implementation for more DMACs
Thread-Index: AcfD2qT1UAFUCo5oRGOjl8XTRawBTgABoWbA
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Peter Pearse" <peter.pearse@arm.com>
Cc: <linux-kernel@vger.kernel.org>, "Dan Williams" <dan.j.williams@gmail.com>
X-OriginalArrivalTime: 11 Jul 2007 18:02:15.0844 (UTC) FILETIME=[9D5DB640:01C7C3E5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams [mailto:dan.j.williams@gmail.com] 
>On 7/3/07, Peter Pearse <peter.pearse@arm.com> wrote:
>> Hi,
>>
>> The existing DMAC used by the dmaengine API (Intel IOAT) assumes all
>> possible clients can use any available DMA channel.
>>
>> Some other DMACs restrict particular peripherals to 
>particular DMA channels.
>>
>> The patch below (against v2.6.22-rc7) extends the dmaengine 
>implementation
>> to allow such DMACs to differentiate between clients.
>>
>Hi Peter,
>
>Have a look at:
>http://marc.info/?l=linux-raid&m=118290909528910&w=2
>http://marc.info/?l=linux-raid&m=118290909523734&w=2
>
>It seems your requirement could be satisfied by a natural extension of
>the 'dma_cap_mask' implementation.  'dma_cap_mask' allows clients to
>only be notified of channels that meet a certain capability profile.
>
>However since your driver is pretty much guaranteed to be the only
>dmaengine driver in the system you can safely do something like the
>following in your client callback:
>

Peter,

If the client is looking for a specific channel capability, that can be
worked with Dan's version of the interface as he suggests with the
dma_cap_mask.  However, it sounds like you need not just channel
capabilities, but also client capabilities information, which I assume
you would carry in the "void *client_data" that you suggested, allowing
the DMAC itself to Ack/Nak the provisioning.  Dan's other suggestion
below has the client controlling the provisioning by accepting a
particular channel.  If the DMAC is the one that has the restriction
information and needs to enforce the restriction based on the specific
client, I suspect this may not help.

Can you give us an example of exactly how your DMAC restriction works?

Is it possible for you to pull this off with the suggested dma_cap_mask?
The only info the client would need is the particular capability bit for
a specific channel type.

Thanks,
sln
