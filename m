Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYGNPxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYGNPxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYGNPxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:53:37 -0400
Received: from il.qumranet.com ([212.179.150.194]:55130 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbYGNPxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:53:36 -0400
Message-ID: <487B767D.2020202@qumranet.com>
Date: Mon, 14 Jul 2008 18:53:33 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
References: <20080714144828.GA22666@elte.hu> <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org> <20080714151247.GA27145@elte.hu>
In-Reply-To: <20080714151247.GA27145@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>   
>> On Mon, 14 Jul 2008, Ingo Molnar wrote:
>>     
>>>  
>>> +config ILLEGAL_POINTER_VALUE
>>> +       hex
>>> +       default 0 if X86_32
>>> +       default 0xffffc10000000000 if X86_64
>>>       
>> This looks like a singularly bad pointer value on x86-64.
>>
>> Why not pick something that is *guaranteed* to fault? The above looks 
>> like any future setup that supports 41 bits of addressing and has 
>> extended the page tables (yes, it will happen eventually) will find 
>> that to be a perfectly valid address?
>>
>> It's also visually confusing, since it's visually very close to a real 
>> kernel pointer too.
>>
>> Grr.
>>
>> Why not use something sane like 0xdead000000000000, which has the high 
>> bit set but very fundamentally isn't a valid pointer, and never will 
>> be? And which is a *lot* more visually obvious too!
>>     
>
> initially i suggested that too - but such addresses raise a #GP instead 
> of a page fault so their decoding is a bit harder.
>
> We dont do any instruction decoding in #GP handlers to figure out what 
> happened, while in the pagefault case we know which address faulted, 
> etc.
>
> Perhaps we could try to make #GP handlers a bit more informative - 
> although decoding instructions will make things a bit more fragile 
> inevitably.
>
> Perhaps make it 0xffffcdead0000000 ?
>   

We could have the oops handler detect this address range, and point out 
the problem in plain English.

-- 
error compiling committee.c: too many arguments to function

