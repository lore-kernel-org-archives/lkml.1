Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbYLHLAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbYLHLAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYLHLAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:00:22 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:27544 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYLHLAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:00:21 -0500
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW226lDNJVyuUILTI/MLsx
Message-ID: <493CFE3E.7080200@hartkopp.net>
Date: Mon, 08 Dec 2008 12:00:14 +0100
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
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
>>>>> I went through all the 30 odd hrtimer callback functions in the kernel
>>>>> and saw only one that I'm not quite sure of, which is the one in
>>>>> net/can/bcm.c - hence I'm CC-ing the folks responsible for that code.
>>>>>     
>>>>>           
>>>
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

Hrtimers looked an excellent approach to have high resolution timers in 
the Kernel when i moved from the low resolution jiffies to hrtimers - 
also to use the latest timer infrastructure. So why is the removal of 
already used functionality (e.g. to use sock_queue_rcv_skb() from a 
hrtimer callback) a so called 'cleanup' ??

Hrtimers are excellent stuff for timing requirements below 500ns. I use 
them for that reason and i can't see the real benefit of your cleanup.

The current hrtimer code is settled, does exactly what is expected and 
gives an upgrade path from other timer infrastructures if you need 
higher resolutions. That's the way it should be and the way it was 
obviously designed by Thomas.

So your functionality reduction unfortunately get's a NACK from me ... 
sorry.

Best regards,
Oliver

