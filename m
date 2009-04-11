Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbZDKUWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbZDKUWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbZDKUWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:22:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38105 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbZDKUWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:22:01 -0400
Message-ID: <49E0FBC6.3050600@garzik.org>
Date: Sat, 11 Apr 2009 16:21:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <49E0D47B.9070205@garzik.org> <20090411203246.513a0892@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0904111250370.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904111250370.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 11 Apr 2009, Alan Cox wrote:
>>> 	  The spec describes the sector size as
>>> 	  "512, 1k, 2k, 4k, 8k, etc."   It will be interesting to reach
>>> 	  "etc" territory.
>> Over 4K will be fun.
> 
> And by "fun", you mean "irrelevant".
> 
> If anybody does that, they'll simply not work. And it's not worth it even 
> trying to handle it.

FSVO trying to handle...

At the driver level, it would be easy to clamp sector size to 4k, and 
point the scatterlist to a zero-filled region for the >4k portion of 
each sector.  Inefficient, sure, but it is low-cost to the driver and 
gives the user something other than a brick.

	if (too_large_sector_size)
		nvmhci_fill_sg_clamped_interleave()
	else
		nvmhci_fill_sg()

Regards,

	Jeff



