Return-Path: <linux-kernel-owner+w=401wt.eu-S1764902AbXG2Pl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764902AbXG2Pl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761278AbXG2PlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:41:20 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:64262 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760567AbXG2PlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:41:19 -0400
Date: Sun, 29 Jul 2007 09:41:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: IRQF_DISABLED problem
In-reply-to: <fa./08N/HtpJQ6zg8Xc1K5pP6/aKMM@ifi.uio.no>
To: David Miller <davem@davemloft.net>
Cc: arjan@infradead.org, torvalds@linux-foundation.org, matthew@wil.cx,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Message-id: <46ACB510.5060700@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.mb8woD3e5JnT1x6AgEMOmnlVvg0@ifi.uio.no>
 <fa.axY2ukp7kqKVMAidyu4NVN81MbI@ifi.uio.no>
 <fa.tS+LCGnYgeCNRIaF90yH21XBCqI@ifi.uio.no>
 <fa./08N/HtpJQ6zg8Xc1K5pP6/aKMM@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Arjan van de Ven <arjan@infradead.org>
> Date: Fri, 27 Jul 2007 13:11:56 -0700
> 
>> On Thu, 2007-07-26 at 16:17 -0700, Linus Torvalds wrote:
>>> On Thu, 26 Jul 2007, Linus Torvalds wrote:
>>>>  (c) "one IRQF_DISABLED means that everything runs disabled". This is 
>>>>      quite possibly buggy.
>>> (Side note: I'm not claiming this (or it's mirror image (d)) is really any 
>>> better/worse than the current behaviour from a theoretical standpoint, but 
>>> at least the current behaviour is _tested_, which makes it better in 
>>> practice. So if we want to change this, I think we want to change it to 
>>> something that is _obviously_ better).
>> my personal preference would actually be to just never enable
>> interrupts. It's the fastest solution obviously, the most friendly on
>> stack and.. well simplest. Drivers no longer need to play some of the
>> games that they do today. And while there is an argument that this may
>> introduce a bit of latency... I'm not really convinced.
> 
> If you have a "chirpy" serial controller with only a 1 byte
> fifo, even a quite reasonable interrupt handler can cause
> receive characters to get lost if you disable interrupts during
> the entirety of it's execution.
> 
> It really is needed.
> 
> And it's just plain rude to disable interrupts when it isn't
> absolutely necessary.

Does anyone really use those serial controllers with no FIFO anymore? 
They've never been reliable for remotely high speeds..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

