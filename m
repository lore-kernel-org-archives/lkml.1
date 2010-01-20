Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690Ab0ATRyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0ATRyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 12:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499Ab0ATRyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 12:54:38 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45504 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab0ATRyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 12:54:37 -0500
Message-ID: <4B574359.9080308@us.ibm.com>
Date: Wed, 20 Jan 2010 09:54:33 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Athan <linux_kernel_aathan@memeplex.com>
CC: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Gong Cheng <chengg11@yahoo.com>
Subject: Re: Futex hang/lockup problem in 2.6.30+ on AMD64
References: <4B4C3E4F.9060001@memeplex.com> <20100112145213.GB3925@hack> <1263308127.4244.142.camel@laptop> <2375c9f91001120700r4c2e1e05l5e5be3ddc6a13da2@mail.gmail.com> <4B4CA27F.1060102@memeplex.com> <4B568C3A.4080301@memeplex.com>
In-Reply-To: <4B568C3A.4080301@memeplex.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Athan wrote:
> Andrew Athan wrote:
>> Américo Wang wrote:
>>> On Tue, Jan 12, 2010 at 10:55 PM, Peter Zijlstra 
>>> <peterz@infradead.org> wrote:
>>>  
>>>> On Tue, 2010-01-12 at 22:52 +0800, Américo Wang wrote:
>>>>
>>>>   
>>>>>> $ uname -a
>>>>>> Linux UK22 2.6.30-2-amd64 #1 SMP Fri Sep 25 22:16:56 UTC 2009 x86_64
>>>>>> GNU/Linux
>>>>>>         
>>>> Does a recent kernel work?
>>>>
>>>>
>>>>     
>>>
>>> Ah, I just wanted to ask the same question, adding the original reporter
>>> Gong Cheng into Cc...
>>>
>>> Gong, could you reproduce it on the latest kernel? And what is your 
>>> .config?
>>>
>>> Thanks!
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>   
>> Due to remote location of the hardware and I haven't been able to test 
>> a more recent (or older) kernel.  Remote hands have put a KVM on the 
>> box as of an hour ago, so I hope to have some information for you in a 
>> day or two.
>>
>> A.
>>
> 
> 
> I wanted to report that although I have had no luck (so far) running 
> anything more recent than 2.6.30, I was able to revert to 2.6.26.  
> Unfortunately, the application hang still occurs.  I also saw a similar 
> hang of the application running on a 32 bit Intel box, also under 
> 2.6.26.  So far, the hang *always* involves threads stuck on 
> pthread_cond_broadcast()'s  condition variable's internal lock while 
> other threads are waiting on the outer "public" lock.


Are you using real-time scheduling policy or priority inheritance 
(PTHREAD_PRIO_INHERIT)? It is possible to suffer an unbounded priority 
inversion on the internal condvar data lock in the current distro 
implementations of glibc.


> These other 
> threads are *not* yet (nor about to) pthread_cond_wait().  I saw a 
> message from Darren Hart (subject "Re: Problems with futex") in response 
> to someone who apparently was having futex problems in 2.6.27, so I'm 
> still operating under the assumption that this is not an application bug.

Those all turned out to be application issues with one exception which 
had already been fixed upstream.


> Over the next couple of days, I will be running a version of the 
> application in which I replaced the pthread_cond calls with simpler 
> locks, in the hopes that it won't hang (because I'm hoping the 
> underlying implementation in pthreads uses a different set of futex 
> opcodes).
> 
> Andrew Athan
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
