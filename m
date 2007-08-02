Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbXHBPlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbXHBPlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXHBPk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:40:56 -0400
Received: from rtr.ca ([64.26.128.89]:4957 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbXHBPkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:40:55 -0400
Message-ID: <46B1FB04.9010802@rtr.ca>
Date: Thu, 02 Aug 2007 11:40:52 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: David Miller <davem@davemloft.net>, arjan@infradead.org,
       torvalds@linux-foundation.org, matthew@wil.cx, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: IRQF_DISABLED problem
References: <fa.mb8woD3e5JnT1x6AgEMOmnlVvg0@ifi.uio.no> <fa.axY2ukp7kqKVMAidyu4NVN81MbI@ifi.uio.no> <fa.tS+LCGnYgeCNRIaF90yH21XBCqI@ifi.uio.no> <fa./08N/HtpJQ6zg8Xc1K5pP6/aKMM@ifi.uio.no> <46ACB510.5060700@shaw.ca>
In-Reply-To: <46ACB510.5060700@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> David Miller wrote:
>> From: Arjan van de Ven <arjan@infradead.org>
>> Date: Fri, 27 Jul 2007 13:11:56 -0700
>>
>>> On Thu, 2007-07-26 at 16:17 -0700, Linus Torvalds wrote:
>>>> On Thu, 26 Jul 2007, Linus Torvalds wrote:
>>>>>  (c) "one IRQF_DISABLED means that everything runs disabled". This 
>>>>> is      quite possibly buggy.
>>>> (Side note: I'm not claiming this (or it's mirror image (d)) is 
>>>> really any better/worse than the current behaviour from a 
>>>> theoretical standpoint, but at least the current behaviour is 
>>>> _tested_, which makes it better in practice. So if we want to change 
>>>> this, I think we want to change it to something that is _obviously_ 
>>>> better).
>>> my personal preference would actually be to just never enable
>>> interrupts. It's the fastest solution obviously, the most friendly on
>>> stack and.. well simplest. Drivers no longer need to play some of the
>>> games that they do today. And while there is an argument that this may
>>> introduce a bit of latency... I'm not really convinced.
>>
>> If you have a "chirpy" serial controller with only a 1 byte
>> fifo, even a quite reasonable interrupt handler can cause
>> receive characters to get lost if you disable interrupts during
>> the entirety of it's execution.
>>
>> It really is needed.
>>
>> And it's just plain rude to disable interrupts when it isn't
>> absolutely necessary.
> 
> Does anyone really use those serial controllers with no FIFO anymore? 
> They've never been reliable for remotely high speeds..

There's another thread on lkml currently about this exact issue,
whereby the UART "fifo nearly full" interrupt isn't getting in quickly
enough for the kernel to de-assert RTS in time..
