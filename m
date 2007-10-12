Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbXJLMqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbXJLMqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760597AbXJLMqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:46:35 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:36514 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760381AbXJLMqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:46:33 -0400
Message-ID: <470F6C43.4090905@aitel.hist.no>
Date: Fri, 12 Oct 2007 14:44:51 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
References: <20071012082534.GB1962@ff.dom.local> <470F337A.9090205@aitel.hist.no> <20071012091213.GC1962@ff.dom.local>
In-Reply-To: <20071012091213.GC1962@ff.dom.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On Fri, Oct 12, 2007 at 10:42:34AM +0200, Helge Hafting wrote:
>   
>> Jarek Poplawski wrote:
>>     
>>> On 04-10-2007 07:23, Nick Piggin wrote:
>>>  
>>>       
>>>> According to latest memory ordering specification documents from Intel and
>>>> AMD, both manufacturers are committed to in-order loads from cacheable 
>>>> memory
>>>> for the x86 architecture. Hence, smp_rmb() may be a simple barrier.
>>>>    
>>>>         
>>> ...
>>>
>>> Great news!
>>>
>>> First it looks like a really great thing that it's revealed at last.
>>> But then... there is probably some confusion: did we have to use
>>> ineffective code for so long?
>>>  
>>>       
>> You could have tried the optimization before, and
>> gotten better performance. But if without solid knowledge that
>> the optimization is _valid_, you risk having a kernel
>> that performs great but suffer the occational glitch and
>> therefore is unstable and crash the machine "now and then".
>> This sort of thing can't really be figured out by experimentation, because
>> the bad cases might happen only with some processors, some
>> combinations of memory/chipsets, or with some minimum
>> number of processors.  Such problems can be very hard
>> to find, especially considering that other plain bugs also
>> cause crashes.
>>
>> Therefore, the "ineffective code" was used because it was
>> the only safe alternative. Now we know, so now we may optimize.
>>     
>
> Sorry, I don't understand this logic at all. Since bad cases
> happen independently from any specifications and Intel doesn't
> take any legal responsibility for such information, it seems we
> should better still not optimize?
>   
The point is that we _trust_ intel when they says "this will work".
Therefore, we can use the optimizations. It was never about
legal matters. If we didn't trust intel, then we couldn't
use their processors at all.

We couldn't take the chance before. It was not documented
to work, verification by testing would not be trivial at all for
this case.
Linux is about "stability first, then performance".
Now we _know_ that we can have this optimization without
compromising stability. Nobody knew before!

Helge Hafting
