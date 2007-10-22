Return-Path: <linux-kernel-owner+w=401wt.eu-S1751166AbXJVVRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbXJVVRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 17:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXJVVQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 17:16:53 -0400
Received: from sa14.bezeqint.net ([192.115.104.29]:46866 "EHLO
	sa14.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbXJVVQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 17:16:52 -0400
Message-ID: <471D133E.90105@panasas.com>
Date: Mon, 22 Oct 2007 23:16:46 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>	<1193076664-13652-10-git-send-email-jens.axboe@oracle.com>	<Pine.LNX.4.64.0710222137520.7105@anakin>	<alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu>
In-Reply-To: <20071022211617.31f5c63d@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct. 22, 2007, 22:16 +0200, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 22 Oct 2007 12:49:40 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>
>> On Mon, 22 Oct 2007, Geert Uytterhoeven wrote:
>>> Better safe than sorry...
>>>
>>> Is it possible that a chain entry pointer has bit 1 set on architectures
>>> (e.g. m68k) where the natural alignment of 32-bit quantities is _2_ bytes,
>>> not 4?
>> Better make sure that such alignment never happens... But no, I don't 
>> think it will, since these things would generally always have to be 
>> allocated with an allocator, and the *allocator* won't return 2-byte 
>> aligned data structures.
> 
> No - but a structure which has other objects in it before the object
> being written out may well be 2 byte aligned on M68K and some of the
> other externally 16bit platforms - ditto local dynamic objects.
> 
> Why can't we just make the list one item longer than the entry count and
> stick a NULL on the end of it like normal people ? Then you need one bit
> which ought to be safe for everyone (and if the bit is a macro any CPU
> warped enough to have byte alignment is surely going to have top bits
> spare...)

Alternatively, I proposed to check for end of list in sg_next 
by calling it with the next iterator value and number of list elements.
We tried that patch here and it seems like a reasonable alternative.
If folks are interested, I can send the full patch for review.

> 
> Alan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

