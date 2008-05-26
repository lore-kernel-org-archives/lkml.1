Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYEZJaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYEZJaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYEZJ3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:29:54 -0400
Received: from il.qumranet.com ([212.179.150.194]:37257 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbYEZJ3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:29:54 -0400
Message-ID: <483A8310.6030309@qumranet.com>
Date: Mon, 26 May 2008 12:29:52 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH] kmemcheck: SMP support
References: <20080523141759.GA1833@damson.getinternet.no>	 <20080523150622.GA9782@elte.hu> <19f34abd0805230830o3af93956h8152de3f6e350a09@mail.gmail.com>
In-Reply-To: <19f34abd0805230830o3af93956h8152de3f6e350a09@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Fri, May 23, 2008 at 5:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
>   
>> Vegard, wanna have a look at introducing per CPU kernel pagetables? I
>> tried that once in the past and it wasnt too horrible. (the patches are
>> gone though) We could do it before bringing other CPUs online, i.e. much
>> of the really yucky boot time pagetable juggling phase would be over
>> already. Hm?
>>     
>
> Ingo.
>
> It really doesn't matter how easy it was for you.
>
> You're one of the x86 maintainers.
>
> And I think you're forgetting how hard these things are for a newbie.
> I don't even know which one comes first of pmds and puds.
>
> Per-cpu page tables sounds about on the same scale of as, say,
> rewriting the VM or some other major subsystem. Epic!
>
>   

You might be able to pull off a simple implementation using 
paravirt_ops, without impacting the core VM.

Basically, you keep the current global pagetables, but never set them as 
real pagetables.  Instead you keep per-cpu copies of these pagetables 
and sync them from the master pagetable as needed.

-- 
error compiling committee.c: too many arguments to function

