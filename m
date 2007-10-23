Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbXJWALk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbXJWALk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbXJWALc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:11:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39783 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbXJWALb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:11:31 -0400
Message-ID: <471D3C26.3020807@garzik.org>
Date: Mon, 22 Oct 2007 20:11:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <Pine.LNX.4.64.0710222137520.7105@anakin> <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu> <471D145A.40904@garzik.org> <20071022214707.GJ17536@waste.org> <20071022235251.656b9cad@the-village.bc.nu> <20071022234622.GT19691@waste.org>
In-Reply-To: <20071022234622.GT19691@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Mon, Oct 22, 2007 at 11:52:51PM +0100, Alan Cox wrote:
>> On Mon, 22 Oct 2007 16:47:07 -0500
>> Matt Mackall <mpm@selenic.com> wrote:
>>
>>> On Mon, Oct 22, 2007 at 05:21:30PM -0400, Jeff Garzik wrote:
>>>> Alan Cox wrote:
>>>>> Why can't we just make the list one item longer than the entry count and
>>>>> stick a NULL on the end of it like normal people ?
>>>> Certainly seems safer than the current "let's run off the end of the 
>>>> list if anything bad happens" setup...  And I do not think allocating 
>>>> n+1 scatterlist entries will have much of a negative impact.
>>> It'll mean m-1 scatterlists fit on a slab.
>> Is that really a credible space issue ?
> 
> Yes. Especially if m is 2 or 1. A scatterlist on 64-bit x86 looks like
> it takes 32 bytes, which means 128 elements fit on a page. One more
> spills - ouch!

  ...and its trivial to reduce that number to 127 without noticeable 
effect, really.

	Jeff



