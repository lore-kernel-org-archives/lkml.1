Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYL3Wrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYL3Wrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYL3Wrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:47:31 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:22054 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYL3Wrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:47:31 -0500
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW226lDNJVyuUMITI/P7ox
Message-ID: <495AA4BB.8020903@hartkopp.net>
Date: Tue, 30 Dec 2008 23:46:19 +0100
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH] hrtimer: removing all ur callback modes
References: <1227613431.4259.1537.camel@twins> <1228385830.5092.43.camel@twins> <493BB1EB.5000004@hartkopp.net> <493BC8A8.2030200@hartkopp.net> <1228731359.5778.18.camel@twins> <493E2725.7090305@hartkopp.net> <1228810331.12729.59.camel@twins> <20081209105902.GB21618@elte.hu>
In-Reply-To: <20081209105902.GB21618@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>   
>>> ps. What is the intended release for this hrtimer cleanup? 2.6.29?
>>>       
>> I think so, Thomas, Ingo?
>>     
>
> yes, 2.6.29.
>
> 	Ingo
>   

AFAICS the commit ca109491f612aab5c8152207631c0444f63da97f

"hrtimer: removing all ur callback modes" with "Impact: cleanup, move 
all hrtimer processing into hardirq context"

did not find it's way into linux-2.6.git - is there any reason for this?

I reworked some of my code in net/can/bcm.c so that it uses tasklets in 
the cases i needed the soft-irq context and therefore it can cope with 
the hrtimers running always in hard-irq context now.

I'll send a patch to Dave the next days after some more testing on your 
latest sched-devel -tip tree. It works fine so far. From my side you can 
go ahead with the hrtimer reduction to hard-irq context (for 2.6.29).

Regards,
Oliver

