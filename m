Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbXEJITb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbXEJITb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbXEJITS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:19:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:61199 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686AbXEJITP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=Z4cLHQfN9JUgpNiBmzqsZ3kJfn8dLUz2KW8hwoSBI2pW21FWqkclb//QpuQn0+Qe9kIoA7ApNxQqZ8UzJazg9Gp5NqSsmQx+yFl4CklJmHRXUudg6QZrrGa/1f3fti5EE6ZWkzg3vNsGWqdUb9m9Vfns+umUporJ10WMssGe7gY=
Date: Thu, 10 May 2007 10:19:00 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Li Yu <raise.sail@gmail.com>
cc: Steven Rostedt <srostedt@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Hi, I have one question about rt_mutex.
In-Reply-To: <4642CB06.2080409@gmail.com>
Message-ID: <Pine.LNX.4.64.0705100947570.12299@frodo.shire>
References: <4642CB06.2080409@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 May 2007, Li Yu wrote:

> Hi, Steven.
>
> Nice to meet you again.
>
> I have read the rt-mutex-design.txt that you wrote. That is excellent
> description of rt_mutex. But I have a question for rt_mutex.
>
> As you said:
>
>
>> Now since mutexes can be defined by user-land applications, we don't
> want a DOS
>> type of application that nests large amounts of mutexes to create a large
>> PI chain, and have the code holding spin locks while looking at a large
>> amount of data. So to prevent this, the implementation not only implements
>> a maximum lock depth, but also only holds at most two different locks at a
>> time, as it walks the PI chain. More about this below.
>
> After read the implementation of rt_mutex_adjust_prio_chain(), I found
> the we really require maximin lock depth (1024 default), but I can not
> see the check for more same locks duplication. Does this doc is
> inconsistent with code?
>
> Thanks in advanced.
>
> Good luck.
> - Li Yu

At the label "again:" inside rt_mutex_adjust_prio_chain() no spinlocks are 
held. That is the kernel can reschedule at that point in the loop. So if 
you as a priority X task try to take a lock you will not delay any higher 
priority than X by more than the amount of time it takes to go 
around in the loop once. The max lock depth is just an extra safety.

The whole idea in a priority based real-time system is that the latency on 
priorty X only depends on what is going on at priority X and higher 
(including interrupt handlers). What ever goes on at lower priority can only
interfere with a fixed, predetermined, small amount of jitter.

Esben

> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
