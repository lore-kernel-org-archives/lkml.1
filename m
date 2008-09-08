Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbYIHO4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbYIHO4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYIHO4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:56:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45147 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750885AbYIHO4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:56:34 -0400
Message-ID: <48C53D20.604@sgi.com>
Date: Mon, 08 Sep 2008 07:56:32 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 07/13] sched: Reduce stack size requirements in kernel/sched.c
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>	 <20080906235037.880702000@polaris-admin.engr.sgi.com>	 <1220783087.8687.73.camel@twins.programming.kicks-ass.net>	 <20080907040009.611ac986.akpm@linux-foundation.org> <1220792750.8687.88.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1220792750.8687.88.camel@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sun, 2008-09-07 at 04:00 -0700, Andrew Morton wrote:
>> On Sun, 07 Sep 2008 12:24:47 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> get_online_cpus() can sleep, but you just disabled preemption with those
>>> get_cpumask_var() horribles!
>> make cpu_hotplug.refcount an atomic_t.
> 
> A much easier fix is just re-ordering those operations and do the
> get_online_cpus() before disabling preemption. But it does indicate this
> patch series isn't carefully constructed.

Yes, it's mostly a hunt for comments on my part... ;-)
> 
>>> Couldn't be arsed to look through the rest, but I really hate this
>>> cpumask_ptr() stuff that relies on disabling preemption.
>> that's harder to fix ;)
> 
> Looking at more patches than just the sched one convinced me more that
> this approach isn't a good one. It seems to make code much more
> fragile. 
> 
> See patch 9, there it was needed to draw out the callgraph in order to
> map stuff to these global variables - we're adding global dependencies
> to code that didn't have any, increasing complexity.

Again, yes, as I got farther into that one, it became clear that having
static cpumask_t temps over too large a range was ending up very messy.

Thanks,
Mike

