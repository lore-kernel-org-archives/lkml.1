Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYHVNAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYHVNAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 09:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYHVNAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 09:00:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38801 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbYHVNAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 09:00:43 -0400
Date: Fri, 22 Aug 2008 09:00:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] ftrace: warn on failure to disable mcount callers
In-Reply-To: <20080822064634.GU14110@elte.hu>
Message-ID: <alpine.DEB.1.10.0808220854550.14314@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808201237210.27481@gandalf.stny.rr.com> <20080821084418.GJ28386@elte.hu> <alpine.DEB.1.10.0808211030300.20825@gandalf.stny.rr.com> <20080822064634.GU14110@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Aug 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +			WARN_ON_ONCE(1);
> > +			pr_info("ftrace faulted on modifying ");
> > +			print_ip_sym(ip);
> > +			break;
> > +		case 2:
> > +			WARN_ON_ONCE(1);
> > +			pr_info("ftrace failed to modify ");
> > +			print_ip_sym(ip);
> > +			print_ip_ins(" expected: ", call);
> > +			print_ip_ins(" actual: ", (unsigned char *)ip);
> > +			print_ip_ins(" replace: ", nop);
> > +			printk(KERN_CONT "\n");
> > +			break;
> 
> hm, i think it makes little sense to only print out the stacktrace once, 
> but to print out the rest all the time.

Actually, the more functions that are printed the easier it is to find 
where things went wrong. The backtrace is only to trigger automated tools,
and helps very little in diagnosing the problem.

I had to examine several functions to figure out the issue with the weak
symbols.

> 
> If there's such a failure then ftrace should warn once, with stacktrace 
> and everthing else, and turn itself off permanently. That makes it sure 
> that we 1) get the report 2) dont spam the user 3) keep the system 
> working 4) turn off the malfunctioning component.

The backtrace should give us 1 without a problem. In fact if we do 2, 
they are more likely to complain ;-)

I think 3 and 4 are related, and I agree, if this is detected, we turn 
ftrace off.

Note, this only prints out on boot up and module loading. The spamming
should not be that bad.

-- Steve

