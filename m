Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbXJREOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbXJREOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbXJREOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:14:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51924 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbXJREOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:14:33 -0400
Message-ID: <4716DD93.4090200@pobox.com>
Date: Thu, 18 Oct 2007 00:14:11 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org> <4716D6B1.8010309@rtr.ca> <alpine.LFD.0.999.0710172100420.26902@woody.linux-foundation.org> <4716DB9A.2060809@rtr.ca>
In-Reply-To: <4716DB9A.2060809@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Linus Torvalds wrote:
>>
>> On Wed, 17 Oct 2007, Mark Lord wrote:
>>> It would be good to have something soon-ish.
>>> This "dead at boot time" issue is impacting the general ability to test
>>> patches against latest -git in time for the current merge window.
>>
>> In the meantime, does the patch I sent out help people? I'd like to 
>> get feedback, but I'm a lazy bum, and don't use DEBUG_PAGEALLOC 
>> myself, so I was hoping that people who actually see this could 
>> comment on my untested suggestion.
> 
> Oh.. so this bug is supposed to only bite with DEBUG_PAGEALLOC=y ??
> 
> Then something else is broken, perhaps.  I just saw a long traceback
> scroll off the top of the screen, with lots of bio_* functions in the list
> and assumed it was the same bug.
> 
> Mmm.. I'll get out the camera and try it again now..

I'm currently bisecting on two machines (sata_mv and sata_nv).  sata_mv 
suddenly started spewing errors in recent kernels, but kernels from ~48 
hours ago are just fine.  AMD64 sata_nv machine will simply lock up if I 
push it too hard.  Again, reproducible, and kernels from ~48 hours ago 
are fine.

AHCI machine so far seems fine (kernel ~24 hours ago), storage-wise, but 
the hda_intel audio decided to stop working :)

I'm quite happy to test patches, but I never run with DEBUG_PAGEALLOC so 
that shouldn't be causing the problems here.

	Jeff



