Return-Path: <linux-kernel-owner+w=401wt.eu-S1762453AbXJRHag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762453AbXJRHag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 03:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbXJRHa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 03:30:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39993 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117AbXJRHa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 03:30:26 -0400
Message-ID: <47170B83.7090802@garzik.org>
Date: Thu, 18 Oct 2007 03:30:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Mark Lord <lkml@rtr.ca>, Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org> <4716D6B1.8010309@rtr.ca> <alpine.LFD.0.999.0710172100420.26902@woody.linux-foundation.org> <4716EE37.9010701@rtr.ca> <4716F061.50103@rtr.ca> <4716F2FC.70400@garzik.org> <20071018070930.GE5063@kernel.dk>
In-Reply-To: <20071018070930.GE5063@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Oct 18 2007, Jeff Garzik wrote:
>> Mark Lord wrote:
>>> Mark Lord wrote:
>>>> Linus Torvalds wrote:
>>>>> On Wed, 17 Oct 2007, Mark Lord wrote:
>>>>>> It would be good to have something soon-ish.
>>>>>> This "dead at boot time" issue is impacting the general ability to test
>>>>>> patches against latest -git in time for the current merge window.
>>>>> In the meantime, does the patch I sent out help people?
>>>> Your patch from this posting http://lkml.org/lkml/2007/10/17/285
>>>> does not seem to make much difference here.
>>>>
>>>> It still crashes at exactly the same place.
>>> However, Jens's patch from that same thread:
>>>     http://lkml.org/lkml/2007/10/17/269
>>> ..allowed me to boot and post this followup message from -git12
>>> Jeff: try that one.
>> That's already in my upstream kernel, here.  commits
>> ba951841ceb7fa5b06ad48caa5270cc2ae17941e and 
>> a3bec5c5aea0da263111c4d8f8eabc1f8560d7bf.
>>
>> sata_mv and sata_nv still reliably poop themselves here, whereas its rock 
>> solid with 2.6.23.1.  Sounds like different issues from yours, as I see a 
>> stream of SATA errors on the bad kernels, errors which are often a symptom 
>> of something whacked in the DMA engine (misprogramming causes the silicon 
>> to generate bogus FIS's, which the device then chokes on)
> 
> Do you know if this poop involves the segment padding that sometimes
> goes on in libata?

Definitely not, in this case -- it's all ATA, nothing ATAPI.

It throws SError { Handshk } which then triggers the EH to reset the 
link, and so it goes, over and over :)  The same thing happens when I 
intentionally screw up the PRD tables.  Not much more data points than 
that, so far.

I'll try the SCSI_MAX_SG_SEGMENTS patch too, to see if that fixes things.

	Jeff



