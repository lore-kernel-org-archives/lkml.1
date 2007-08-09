Return-Path: <linux-kernel-owner+w=401wt.eu-S1760349AbXHISVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349AbXHISVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbXHISU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:20:57 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:54293 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbXHISUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:20:55 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Organization: IBM Linux Technology Center
To: "Robert de Vries" <robert.h.de.vries@gmail.com>
Subject: Re: [PATCH RT] Only run softirqs from the irq thread if the irq affinity is set to 1 CPU
Date: Thu, 9 Aug 2007 11:20:42 -0700
User-Agent: KMail/1.9.6
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "john stultz" <johnstul@us.ibm.com>
References: <1186605752.29097.18.camel@localhost.localdomain> <1186609529.14769.8.camel@localhost.localdomain> <47db5b910708090249k2c80e3e8tdc062d89ed4359fc@mail.gmail.com>
In-Reply-To: <47db5b910708090249k2c80e3e8tdc062d89ed4359fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091120.42281.dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007 02:49:27 Robert de Vries wrote:
> On 8/8/07, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Wed, 2007-08-08 at 14:16 -0700, Darren Hart wrote:
> > > It seems to me that this patch will reduce the frequency of
> > > irqd/softirqd starvation, but the core problem still exists: softirq
> > > tasks can't migrate to other CPUs to perform their work if a higher
> > > priority task preempts them. I'm wondering if we want to keep special
> > > casing things to minimize the problem or not - seems to me the worst
> > > case is still the same - and isn't the worst case the only case that
> > > matters (for -rt)?
> >
> > softirq tasks should never migrate to other CPUs. A softirq exists in
> > every CPU. So if you trigger a softirq on CPU1 it will only run on CPU1.
> > If a high priority task preempts it, that same softirq can still run on
> > other CPUS. Only the thread that was preempted wont switch. But that's
> > the characteristic of softirqs, and that's how people who use them in
> > development expect them to work.
>
> Wouldn't a developer of a real-time system configure the system so
> that interrupts do not interfere with the real-time tasks running on a
> specific CPU?
> In other words, is this problem not simply a misconfiguration of the
> system? I personally redirect all interrupts away from the CPU's where my
> real-time tasks run and only allow the interrupts that I want to
> handle in my application on the CPU's where I handle them so as to
> minimize latency.

I think the goal is to try and have a generally robust default setup - but the 
interrupt shielding you are suggesting seems like it will become more and 
more relevant as the number of CPUs increases.

-- 
Darren Hart
IBM Linux Technology Center
Realtime Linux Team
