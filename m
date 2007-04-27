Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbXD0XBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbXD0XBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757873AbXD0XBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:01:08 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:57923 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1757692AbXD0XBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:01:05 -0400
Date: Fri, 27 Apr 2007 15:26:04 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200704280041.17617.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.63.0704271521230.10565@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <200704280004.47683.rjw@sisk.pl>  <alpine.LFD.0.98.0704271506080.9964@woody.linux-foundation.org>
 <200704280041.17617.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:

>>> We're freezing many of them just fine. ;-)
>>
>> And can you name a _single_ advantage of doing so?
>
> Yes.  We have a lot less interdependencies to worry about during the whole
> operation.
>
>> It so happens, that most people wouldn't notice or care that kmirrord got
>> frozen (kernel thread picked at random - it might be one of the threads
>> that has gotten special-cased to not do that), but I have yet to hear a
>> single coherent explanation for why it's actually a good idea in the first
>> place.
>
> Well, I don't know if that's a 'coherent' explanation from your point of view
> (probably not), but I'll try nevertheless:
> 1) if the kernel threads are frozen, we know that they don't hold any locks
> that could interfere with the freezing of device drivers,

does teh process of freezing really wait until all locks have been released?

> 2) if they are frozen, we know, for example, that they won't call user mode
> helpers or do similar things,

this won't matter unless the user mode helpers are going to do I/O or other 
permanent changes

> 3) if they are frozen, we know that they won't submit I/O to disks and
> potentially damage filesystems (suspend2 has much more problems with that
> than swsusp, but still.  And yes, there have been bug reports related to it,
> so it's not just my fantasy).

if you have the filesystems checkpointed then I/O after the freeze won't matter 
as you just revert to the checkpoint (and since this is going to be thrown away 
it can stay in ram)

if we are willing to make a break with the past to implement the new snapshot 
capability, we should be able to use the LVM snapshot code to handle the 
filesystem

David Lang

> Probably some other people can say more about it.
>
>> And it has added totally idiotic code to every single kernel thread main
>> loop. For _no_ reason, except that the concept was broken, and needed more
>> breakage to just make it work.
>
> It is actually useful for some things other than the hibernation/suspend, the
> code is not idiotic (it's one line of code in the majority of cases) and you
> should take that "I hate everything even remotely related to hibernation" hat
> off, really.
>
> Greetings,
> Rafael
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
