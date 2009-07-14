Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbZGNH1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbZGNH1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 03:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZGNH1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 03:27:45 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:41472 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbZGNH1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 03:27:44 -0400
Message-ID: <4A5C3361.70007@nortel.com>
Date: Tue, 14 Jul 2009 01:27:29 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Douglas Niehaus <niehaus@ittc.ku.edu>
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
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <002301ca0403$47f9d9d0$d7ed8d70$@tlh@comcast.net> <4A5BC7AB.4020703@ittc.ku.edu>
In-Reply-To: <4A5BC7AB.4020703@ittc.ku.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 07:27:31.0938 (UTC) FILETIME=[8CCB5420:01CA0454]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Douglas Niehaus wrote:

>      (1.1) Will the use of system services (system calls) by RT threads 
> need to be explicitly supported by, perhaps, explicitly making the 
> schedulers of *other* threads also using those system calls aware of 
> that and take it into account to make those other tasks non-preemptible 
> while holding system call related locks.
> 
>      (1.2) Can Linux SMP ever support this in an acceptable manner since 
> locks associated with systems services are shared across CPU boundaries. 
> THus, I can isolate a set of RT tasks on a CPU easily, and they are well 
> isolated and can run under strict predictability, *until they use a 
> system call that uses a lock*. Then, the system call is an interaction 
> channel with every other thread on the system using the same system call.


This may be a terminology issue, but I think it would be more correct to
say that the lock is the interaction channel, not the system call, and
it is an interaction channel with every other entity on the system using
the same lock.  Depending on the specific lock, this could be other
userspace tasks, kernel threads, or even hardware interrupt handlers.

This goes back to your first question of which system services an RT
task can use while maintaining schedulability analysis.  Unfortunately
this may be a moving target, since the exact answer depends on what
locks are taken in the underlying kernel implementation.

Chris
