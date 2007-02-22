Return-Path: <linux-kernel-owner+w=401wt.eu-S1751596AbXBVN3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbXBVN3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXBVN3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:29:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:45548 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbXBVN3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:29:53 -0500
Message-ID: <45DD9A9D.4060500@qumranet.com>
Date: Thu, 22 Feb 2007 15:29:01 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Dor Laor <dor.laor@qumranet.com>, Pavel Machek <pavel@ucw.cz>,
       kvm-devel@lists.sourceforge.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers to
 a	central arch-independent location
References: <45D979D3.2020907@qumranet.com>	 <20070219103052.4D23725016B@il.qumranet.com><20070221103733.GI3945@ucw.cz>	 <45DD6CF0.3010509@qumranet.com>	 <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net>	 <1172140490.3531.236.camel@laptopd505.fenrus.org>	 <45DD7330.1030001@qumranet.com>	 <1172142081.3531.243.camel@laptopd505.fenrus.org>	 <45DD94D3.4030102@qumranet.com> <1172149924.3531.260.camel@laptopd505.fenrus.org>
In-Reply-To: <1172149924.3531.260.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> Somthing else that came up in a conversation with Dor: the need for a 
>> clean way to raise a guest interrupt.  The guest may be sleeping in 
>> userspace, scheduled out, or running on another cpu (and requiring an 
>> ipi to get it out of guest mode).
>>     
>
> yeah it'd be nice if I could just call a function for it rather than
> poking into kvm internals ;)
>
>   

Sure.  Please report all inconveniences (they're really bugs) so we can 
fix them.

Poking at kvm internals means you waste your time learning them, and 
later we can't change them.


>> Right now I'm thinking about using the signal machinery since it appears 
>> to do exactly the right thing.
>>     
>
> signals are *expensive* though.
>
>   

I think the expensive part of signals is userspace delivery.  If they 
are always blocked in userspace, they become just another IPC channel.

I plan to add a signal mask to KVM_RUN a la pselect() so that userspace 
can dequeue signals instead of using a signal handler.


> If you design an interrupt interface, it'd rock if you could make it
> such that it is "raise <this> interrupt within <x> miliseconds from
> now", rather than making it mostly synchronous. That way irq mitigation
> becomes part of the interface rather than having to duplicate it all
> over the virtual drivers...
>   

Can't it be done by a helper function using a timer and a signal (or 
whatever mechanism we use to wake up vcpus)?

-- 
error compiling committee.c: too many arguments to function

