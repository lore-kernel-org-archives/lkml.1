Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbZFJMXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbZFJMXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbZFJMXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:23:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZFJMXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:23:25 -0400
Date: Wed, 10 Jun 2009 08:23:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 3/5] tracing/events: modify irq print to new format
In-Reply-To: <20090610094218.GB14860@infradead.org>
Message-ID: <alpine.DEB.2.00.0906100819500.30552@gandalf.stny.rr.com>
References: <20090609014534.790466803@goodmis.org> <20090609014746.709245674@goodmis.org> <20090610094218.GB14860@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Christoph Hellwig wrote:

> On Mon, Jun 08, 2009 at 09:45:37PM -0400, Steven Rostedt wrote:
> > -#define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
> > -#define show_softirq_name(val)			\
> > -	__print_symbolic(val,			\
> > -			 softirq_name(HI),	\
> > -			 softirq_name(TIMER),	\
> > -			 softirq_name(NET_TX),	\
> > -			 softirq_name(NET_RX),	\
> > -			 softirq_name(BLOCK),	\
> > -			 softirq_name(TASKLET),	\
> > -			 softirq_name(SCHED),	\
> > -			 softirq_name(HRTIMER),	\
> > -			 softirq_name(RCU))
> > +#define softirq_name(sirq) sirq##_SOFTIRQ, #sirq
> > +#define show_softirq_name(val)						\
> > +	"%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s>",	\
> > +		softirq_name(HI),					\
> > +		softirq_name(TIMER),					\
> > +		softirq_name(NET_TX),					\
> > +		softirq_name(NET_RX),					\
> > +		softirq_name(BLOCK),					\
> > +		softirq_name(TASKLET),					\
> > +		softirq_name(SCHED),					\
> > +		softirq_name(HRTIMER),					\
> > +		softirq_name(RCU)
> 
> This is a massive readability and maintainabilit  regression over the
> old code.  I now need to add a useless and counter-intuitive %d=%s,
> boilerplate for every new flag I add instead ofa simple line-line
> array entry.
> 
> Also why does show_softirq_name get a val argument passed that's never
> used?  And no, I don't think

That was from the original, I forgot to remove it.

> %d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s is an intuitive
> way to print an enum.

This is a helper macro and has nothing to do with the new format. In fact, 
I'd do something similar with the old format because currently without 
that "%d=%s,..." helper we get in the print format:

	HRTIMER_SOFTIRQ = "HRTIMER"

How is a user tool going to know what value HRTIMER_SOFTIRQ is?

This was a trick I used to evaluate the HRTIMER_SOFTIRQ to an actual 
number that might actually be useful for userland readers.

-- Steve

