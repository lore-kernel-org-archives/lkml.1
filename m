Return-Path: <linux-kernel-owner+w=401wt.eu-S938886AbXHIJti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938886AbXHIJti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbXHIJt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:49:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:51825 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760644AbXHIJt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:49:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=juNa229IJO2L1ZgKIzfMGEC/PhnSwY8xGQ+Udr5JcnO7x5Qm8+6mVgWPNnJJ105YZ3dXiPwqC3i35kRQx3afShE22F62ytqoKAKdaxY9nApgvLdux8u9YgPUFle9m5Skz8E0OF/h7l+Vtu+3bxQNFpHxUV6LtHjw6i/ObdRNpLI=
Message-ID: <47db5b910708090249k2c80e3e8tdc062d89ed4359fc@mail.gmail.com>
Date: Thu, 9 Aug 2007 11:49:27 +0200
From: "Robert de Vries" <robert.h.de.vries@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH RT] Only run softirqs from the irq thread if the irq affinity is set to 1 CPU
Cc: "Darren Hart" <dvhltc@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "john stultz" <johnstul@us.ibm.com>
In-Reply-To: <1186609529.14769.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186605752.29097.18.camel@localhost.localdomain>
	 <200708081416.27500.dvhltc@us.ibm.com>
	 <1186609529.14769.8.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2007-08-08 at 14:16 -0700, Darren Hart wrote:
>
> > It seems to me that this patch will reduce the frequency of irqd/softirqd
> > starvation, but the core problem still exists: softirq tasks can't migrate to
> > other CPUs to perform their work if a higher priority task preempts them.
> > I'm wondering if we want to keep special casing things to minimize the
> > problem or not - seems to me the worst case is still the same - and isn't the
> > worst case the only case that matters (for -rt)?
> >
>
> softirq tasks should never migrate to other CPUs. A softirq exists in
> every CPU. So if you trigger a softirq on CPU1 it will only run on CPU1.
> If a high priority task preempts it, that same softirq can still run on
> other CPUS. Only the thread that was preempted wont switch. But that's
> the characteristic of softirqs, and that's how people who use them in
> development expect them to work.

Wouldn't a developer of a real-time system configure the system so
that interrupts do not interfere with the real-time tasks running on a
specific CPU?
In other words, is this problem not simply a misconfiguration of the system?
I personally redirect all interrupts away from the CPU's where my
real-time tasks run and only allow the interrupts that I want to
handle in my application on the CPU's where I handle them so as to
minimize latency.

    Robert
