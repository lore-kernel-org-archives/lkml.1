Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZGNHo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZGNHo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 03:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbZGNHoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 03:44:55 -0400
Received: from stephens.ittc.ku.edu ([129.237.125.220]:49407 "EHLO
	stephens.ittc.ku.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZGNHoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 03:44:54 -0400
Message-ID: <4A5C3774.6090901@ittc.ku.edu>
Date: Tue, 14 Jul 2009 02:44:52 -0500
From: Douglas Niehaus <niehaus@ittc.ku.edu>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Ted & Syauchen Baker <baker.tlh@comcast.net>,
       "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>,
       "'Henrik Austad'" <henrik@austad.us>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Bill Huey'" <billh@gnuppy.monkey.org>,
       "'Linux RT'" <linux-rt-users@vger.kernel.org>,
       "'Fabio Checconi'" <fabio@gandalf.sssup.it>,
       "'James H. Anderson'" <anderson@cs.unc.edu>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Ted Baker'" <baker@cs.fsu.edu>,
       "'Dhaval Giani'" <dhaval.giani@gmail.com>,
       "'Noah Watkins'" <jayhawk@soe.ucsc.edu>,
       "'KUSP Google Group'" <kusp@googlegroups.com>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <002301ca0403$47f9d9d0$d7ed8d70$@tlh@comcast.net> <4A5BC7AB.4020703@ittc.ku.edu> <4A5C3361.70007@nortel.com>
In-Reply-To: <4A5C3361.70007@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0.1 (stephens.ittc.ku.edu); Tue, 14 Jul 2009 02:44:53 -0500 (CDT)
X-ITTC-MailScanner-Information: Please contact the ISP for more information
X-ITTC-MailScanner-ID: 26A2828F5E.A5FFF
X-ITTC-MailScanner: Found to be clean
X-ITTC-MailScanner-From: niehaus@ittc.ku.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Chris Friesen wrote:
> Douglas Niehaus wrote:
>
>   
>>      (1.1) Will the use of system services (system calls) by RT threads 
>> need to be explicitly supported by, perhaps, explicitly making the 
>> schedulers of *other* threads also using those system calls aware of 
>> that and take it into account to make those other tasks non-preemptible 
>> while holding system call related locks.
>>
>>      (1.2) Can Linux SMP ever support this in an acceptable manner since 
>> locks associated with systems services are shared across CPU boundaries. 
>> THus, I can isolate a set of RT tasks on a CPU easily, and they are well 
>> isolated and can run under strict predictability, *until they use a 
>> system call that uses a lock*. Then, the system call is an interaction 
>> channel with every other thread on the system using the same system call.
>>     
>
>
> This may be a terminology issue, but I think it would be more correct to
> say that the lock is the interaction channel, not the system call, and
> it is an interaction channel with every other entity on the system using
> the same lock.  Depending on the specific lock, this could be other
> userspace tasks, kernel threads, or even hardware interrupt handlers.
>
>   
Sorry, sloppiness on my part while typing quickly, resulting in the 
terminolgy problem of --- my using the wrong terminology.

Yes, the lock, is the interaction channel.

Admittedly, which locks are the interaction channels is correlated with 
which system services are used by threads, but sometimes more and 
sometimes less strongly correlated.

When I explain it to less expert audiences than this, I tend to talk in 
terms of the system services because they at least know what some of 
them are, while many have no idea what the concurrency control in the 
kernel is. They can fairly easily see that if RT tasks use a range of 
services used by generic Linux tasks, then some interaction between RT 
and non-RT tasks is a result.

Still, no excuses, only explanation. Sorry to have over-simplified to 
this audience.

Thanks for clarifying.
> This goes back to your first question of which system services an RT
> task can use while maintaining schedulability analysis.  Unfortunately
> this may be a moving target, since the exact answer depends on what
> locks are taken in the underlying kernel implementation.
>
> Chris
>   
Yes. This is true and is also the point I was trying to make. When 
talking to people about RT over the years I have observed that it is 
often hard to communicate the full cost of the predictability required 
for RT tasks

Extremely detailed information is required, and getting it can be 
expensive. This is one reason why supporting RT in Linux proper is even 
harder than it first appears.

However, I think that while completely arbitrary use of Linux system 
services by RT tasks is extremely complicated, many RT applications can 
be happy using only a small subset of services, and so various classes 
of applications can be supported successfully with merely extreme 
effort, as opposed to completely insane effort.

It is a really hard problem, no doubt, though.

Doug

