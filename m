Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab0BPRCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 12:02:11 -0500
Received: from www.tglx.de ([62.245.132.106]:35852 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131Ab0BPRCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 12:02:09 -0500
Date: Tue, 16 Feb 2010 18:01:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] LTTng0.158 Linux-2629-RT kernel BUG: sleeping function
 called from invalid context at kernel/rtmutex.c:685
In-Reply-To: <20100216164744.GA25115@Krystal>
Message-ID: <alpine.LFD.2.00.1002161757050.2811@localhost.localdomain>
References: <f5a7b3811002160717y65b4577buf53e5784c71575c3@mail.gmail.com> <1266337450.24271.140.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1002161727570.2811@localhost.localdomain> <20100216164744.GA25115@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Mathieu Desnoyers wrote:
> > The function is called from an IPI. That's a LTTNG problem, not a RT one.
> 
> I use del_timer in IPI to delete lttng per-cpu timers on all CPUs. I
> have to do this because timers created with add_timer_on are documented
> to be incompatible with del_timer_sync():
> 
>  * Synchronization rules: Callers must prevent restarting of the timer,
>  * otherwise this function is meaningless. It must not be called from
>  * interrupt contexts. The caller must not hold locks which would prevent
>  * completion of the timer's handler. The timer's handler must not call
>  * add_timer_on(). Upon exit the timer is not queued and the handler is
>  * not running on any CPU.

Errm. The documentation says: 

      "The timer's handler must not call add_timer_on()." 

It's not talking about a timer which was initialized with
add_timer_on().

 And your per cpu timer handlers have no requirement to call
add_timer_on() simply because add/mod_timer() is requeueing the timer
on the same cpu on which the handler runs. 

So the IPI is just a solution for a non existing problem.

Thanks,

	tglx
