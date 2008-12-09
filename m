Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbYLIIHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbYLIIHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 03:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYLIIHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 03:07:42 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:14162 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYLIIHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 03:07:41 -0500
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW226lDNJVyuUOIzI8ObEx
Message-ID: <493E2725.7090305@hartkopp.net>
Date: Tue, 09 Dec 2008 09:07:01 +0100
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] hrtimer: removing all ur callback modes
References: <1227613431.4259.1537.camel@twins>	 <1228385830.5092.43.camel@twins> <493BB1EB.5000004@hartkopp.net>	 <493BC8A8.2030200@hartkopp.net> <1228731359.5778.18.camel@twins>
In-Reply-To: <1228731359.5778.18.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sun, 2008-12-07 at 13:59 +0100, Oliver Hartkopp wrote:
>   
>> Oliver Hartkopp wrote:
>>     
>>> Peter Zijlstra wrote:
>>>       
>>>> On Tue, 2008-11-25 at 12:43 +0100, Peter Zijlstra wrote:
>>>>  
>>>>         
>>>>> Hi,
>>>>>
>>>>> This is an attempt at removing some of the hrtimer complexity by
>>>>> reducing the number of callback modes to 1.
>>>>>
>>>>> This means that all hrtimer callback functions will be ran from 
>>>>> HARD-irq
>>>>> context.
>>>>>
>>>>>           
>> Hi Peter,
>>
>> i ran a heavy load test, which get's (reproducible) the attached outputs ...
>>
>> Maybe it's not that good to define the hrtimer context to be always 
>> hard-irq.
>>     
>
> Thing is, this 'cleanup' removes quite a bit of complexity from the core
> hrtimer code, and afaict your bit is the only thing that cannot seem to
> cope. So I'd rather look at fixing your site than re-introduce softirqs
> to hrtimers.
>
>   

I wouldn't be that sure that all the other sites can cope with it as i 
only detected the problems with my code under heavy load ...

>> Any idea?
>>     
>
> What are the timing constraints of your problem? - I assume they are not
> too aggressive, otherwise you'd not be able to run from softirq, could
> you run from keventd?
>   

I browsed some code that's using hrtimers and found some hopefully good 
example in drivers/s390/crypto/ap_bus.c : They are using the hrtimer to 
schedule a tasklet which is running in soft-irq context:

http://lxr.linux.no/linux+v2.6.27.8/drivers/s390/crypto/ap_bus.c#L1150

This could also be the correct approach for my sock_queue_rcv_skb() 
problem, right?

Regards,
Oliver

ps. What is the intended release for this hrtimer cleanup? 2.6.29?


