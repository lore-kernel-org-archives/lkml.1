Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbYGBLZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbYGBLZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYGBLZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:25:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46969 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbYGBLZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:25:02 -0400
Message-ID: <486B658A.1040203@firstfloor.org>
Date: Wed, 02 Jul 2008 13:24:58 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Leon Woestenberg <leon.woestenberg@gmail.com>
CC: benh@kernel.crashing.org, Arjan van de Ven <arjan@linux.intel.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>, RT <linux-rt-users@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
References: <1214916335.20711.141.camel@pasglop>	 <486B0298.5030508@linux.intel.com> <1214977447.21182.33.camel@pasglop>	 <87zlp0sg4l.fsf@basil.nowhere.org> <c384c5ea0807020419o4d5b9ff1j34d4dc11a41dd2@mail.gmail.com>
In-Reply-To: <c384c5ea0807020419o4d5b9ff1j34d4dc11a41dd2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leon Woestenberg wrote:
> Hello,
> 
> (including linux-rt-users in the CC:, irqthreads are on-topic there)

Actually it's probably not interesting for this case.

> 
> On Wed, Jul 2, 2008 at 1:02 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
>>
>>>> how much of this would be obsoleted if we had irqthreads ?
>>> I'm not sure irqthreads is what I want...
>>>
>> I also think interrupts threads are a bad idea in many cases because
>> their whole "advantage" over classical interrupts is that they can
>> block. Now blocking can be usually take a unbounded potentially long
>> time.
>>
>> What do you do when there are more interrupts in that unbounded time?
>>
> If by irqthreads the -rt implementation is meant, isn't this what happens:
> 
> irq kernel handler masks the source interrupt
> irq handler awakes the matching irqthread (they always are present)
> irqthread is scheduled, does work and returns
> irq kernel unmasks the source interrupt

I described this case. If the interrupt handler blocks for a long
time (as Ben asked for) then the interrupts will not be handled
for a long time. Probably not what you want.

BTW this was not a criticsm of rt linux (in whose context
irqthreads make sense as I explained) , just an explanation why they
imho don't make sense (IMHO) in a non hard rt interruptible kernel
and especially not to solve Ben's issue.

> 
>> Create more interrupt threads?  At some point you'll have hundreds
>> of threads doing nothing when you're unlucky.
>>
> Each irqthread handles one irq.
> So now new irq thread would spawn for any interrupt.

It was a general description of all possible irqthreads.

-Andi
