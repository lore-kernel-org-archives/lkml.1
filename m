Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbYJaSJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbYJaSJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYJaSI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:08:58 -0400
Received: from picard.linux.it ([213.254.12.146]:51510 "EHLO picard.linux.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbYJaSI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:08:57 -0400
X-Greylist: delayed 1185 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2008 14:08:56 EDT
Message-ID: <33120.148.202.77.161.1225476534.squirrel@picard.linux.it>
In-Reply-To: <200810302244.52329.henrik@austad.us>
References: <200810281634.11285.henrik@austad.us>
    <20081030174925.36023f19jy3o832t@feanor.sssup.it>
    <1225387034.7803.182.camel@twins>
    <200810302244.52329.henrik@austad.us>
Date: Fri, 31 Oct 2008 19:08:54 +0100 (CET)
Subject: Re: Deadline scheduling (was: Re: Rearranging layout of code in 
     the scheduler)
From: "Dario Faggioli" <raistlin@linux.it>
To: "Henrik Austad" <henrik@austad.us>
Cc: "Peter Zijlstra" <peterz@infradead.org>, faggioli@gandalf.sssup.it,
       "Ingo Molnar" <mingo@elte.hu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, fabio@gandalf.sssup.it,
       "Michael Trimarchi" <trimarchimichael@yahoo.it>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "gregory.haskins" <gregory.haskins@gmail.com>
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Gio, 30 Ottobre 2008 10:44 pm, Henrik Austad wrote:
>> As to why I'm
>> looking at EDF, I think the answer to that is a bit too long (and
>> not
>> appropriate for this email anyway) so I'll leave that part out.
>> >
>> > Well, I understand that, but it could be interesting... At least to
>> > me.
>
> ok, simply put:
> * give each task a relative deadline (will probably introduce a new
> syscall,
> please don't shoot me).
> * when the task enters TASK_RUNNING, set abosolute deadline to time_now +
> rel_deadline.
> * insert task in rq, sorted by abs_deadline
> * pick leftmost task and run it
> * when task is done, pick next task
>
> that's it.
>
Ok, that is how EDF work, and I know it... I was asking something
different... But nevermind! :-D

>> > > The most interesting part of EDF is not the
>> > > actual scheduler itself (although there are fun issues with that as
>> > > well), but extending the Priority Inheritance framework to deal with
>> > > all the fun cases that come with EDF.
>
> Well, I find EDF intersting because it is so blissfully simple. :-)
>
I agree, EDF is very simple and has a lot of very nice properties...
Problem is do decide how to assign a deadline to a task, if it is not a
classical soft or hard real-time one! :-O

But you're not talking about things like that, aren't you?

> Yes, well, EDF is not optimal for SMP systems, only for single core.
> However,
> you can do a pretty good attempt by assigning tasks to cores in a greedy
> fashion (simply put the next task at the CPU with the lowest load).
>
I definitely agree that hard real time workloads are better handled by
partitioned EDF, but for soft ones, it was sad to suffer from the possible
CPU utilization loss it entails.

Also, what about resources shared by different tasks in different
CPU/partitions? And if you avoid sharing resources between tasks in
different partitions (is that acceptable?), what about system resources,
that are shared by _all_ tasks in the system by definition?

Sorry about asking so much questions, but these are the issues we are
trying to address, and I'm quite interested in knowing if you have any
idea about them. :-)

> No. You should have *either* FIFO/RR *or* EDF, not both at the same time.
>
Oh... Why?

> If
> you absolutely require both, you should at least separate them on a
> per-core
> basis. If you mix them, they need to be aware of the other in order to
> make
> the right descision, and that is not good.
>
Well, obvioulsy it's something that we have to think carefully, but I
can't see any harmful situation in having a deadline based and a fixed
priority based scheduling from where to pick task in (sorry) priority
order.

> Well.. why not just treat *all* RT-tasks as *either* FIFO/RR or EDF?
> Having
> fifo and edf together will complicate things. And, people looking for edf,
> will not use fifo/rr anyway (famous last words).
>
Ok, maybe it's a matter of personal feelings, but I think that such a
design, even more complicated, could be very nice and useful.

>> Which leaves us with the big issue of priority inversion ;-)
>
> Couldn't above idea solve a bit of this? I have some papers on deadline
> inheritance laying aorund somewhere, I can have a look at that, I think it
> was a fairly elegant solution to some of these issues there.
>
Well, I personally think that partitioning _raises_ issues about resource
sharing instead of lightening them... In an OS like Linux is, at least...
:-O

Regards,
Dario Faggioli

PS. Sorry for the webmail... I'm abroad and I've not my laptop with me :-(

