Return-Path: <linux-kernel-owner+w=401wt.eu-S1751108AbXB1CVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbXB1CVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 21:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXB1CVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 21:21:43 -0500
Received: from mail.tmr.com ([64.65.253.246]:53330 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbXB1CVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 21:21:42 -0500
Message-ID: <45E4E736.2050505@tmr.com>
Date: Tue, 27 Feb 2007 21:21:42 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>
CC: Rik van Riel <riel@redhat.com>,
       =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3?= =?ISO-8859-1?Q?n=22?= 
	<jamagallon@ono.com>,
       Hiro Yoshioka <hyoshiok@miraclelinux.com>, davej@redhat.com,
       harlan@artselect.com, nickpiggin@yahoo.com.au, l_allegrucci@yahoo.it,
       linux-kernel@vger.kernel.org, mingo@elte.hu, suparna@in.ibm.com,
       jens.axboe@oracle.com
Subject: Re: SMP performance degradation with sysbench
References: <20070226223645.GA24174@redhat.com>	<98df96d30702261632u7479c9b2sce93f80f68bbc8d0@mail.gmail.com>	<45E37EA3.3060101@redhat.com>	<20070227.130305.424251739.hyoshiok@miraclelinux.com>	<45E3B421.603@redhat.com> <20070227091409.6f3d12f9@werewolf-wl> <45E439E4.5030703@redhat.com> <45E4469C.8000505@grupopie.com>
In-Reply-To: <45E4469C.8000505@grupopie.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paulo Marques wrote:
> Rik van Riel wrote:
>> J.A. Magallón wrote:
>>> [...]
>>> Its the same to answer 4+4 queries than 8 at half the speed, isn't it ?
>>
>> That still doesn't fix the potential Linux problem that this
>> benchmark identified.
>>
>> To clarify: I don't care as much about MySQL performance as
>> I care about identifying and fixing this potential bug in
>> Linux.
> 
> IIRC a long time ago there was a change in the scheduler to prevent a 
> low prio task running on a sibling of a hyperthreaded processor to slow 
> down a higher prio task on another sibling of the same processor.
> 
> Basically the scheduler would put the low prio task to sleep during an 
> adequate task slice to allow the other sibling to run at full speed for 
> a while.
> 
> I don't know the scheduler code well enough, but comments like this one 
> make me think that the change is still in place:
> 
>>     /*
>>      * If an SMT sibling task has been put to sleep for priority
>>      * reasons reschedule the idle task to see if it can now run.
>>      */
>>     if (rq->nr_running) {
>>         resched_task(rq->idle);
>>         ret = 1;
>>     }
> 
> If that is the case, turning off CONFIG_SCHED_SMT would solve the problem.
> 
That may be the case, but in my opinion if this helps it doesn't "solve" 
the problem, because the real problem is that a process which is not on 
a HT is being treated as if it were.

Note that Intel does make multicore HT processors, and hopefully when 
this code works as intended it will result in more total throughput. My 
supposition is that it currently is NOT working as intended, since 
disabling SMT scheduling is reported to help.

A test with MC on and SMT off would be informative for where to look next.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

