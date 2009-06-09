Return-Path: <linux-kernel-owner+w=401wt.eu-S932138AbZFIM5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbZFIM5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932067AbZFIM5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:57:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47311 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbZFIM5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:57:07 -0400
Date: Tue, 9 Jun 2009 08:57:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 0/5] simplify the print fmt in the event format
 files
In-Reply-To: <20090609120729.GB25586@elte.hu>
Message-ID: <alpine.DEB.2.00.0906090852390.17452@gandalf.stny.rr.com>
References: <20090609014534.790466803@goodmis.org> <20090609120729.GB25586@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Jun 2009, Ingo Molnar wrote:
> 
> > 
> > We go from this:
> > 
> >  print fmt: "irq=%d handler=%s", REC->irq, (char *)((void *)REC + REC->__data_loc_name)
> > 
> > to this:
> > 
> >  format: irq=<int:irq> handler=<string:name>
> > 
> > and this:
> > 
> >   print fmt: "softirq=%d action=%s", REC->vec, ({ static const struct trace_print_flags symbols[] = { { HI_SOFTIRQ, "HI" }, { TIMER_SOFTIRQ, "TIMER" }, { NET_TX_SOFTIRQ, "NET_TX" }, { NET_RX_SOFTIRQ, "NET_RX" }, { BLOCK_SOFTIRQ, "BLOCK" }, { TASKLET_SOFTIRQ, "TASKLET" }, { SCHED_SOFTIRQ, "SCHED" }, { HRTIMER_SOFTIRQ, "HRTIMER" }, { RCU_SOFTIRQ, "RCU" }, { -1, ((void *)0) }}; ftrace_print_symbols_seq (p, REC->vec, symbols); })
> > 
> > To this:
> > 
> > format: softirq=<int:vec> action=<sym:vec:0=HI,1=TIMER,2=NET_TX,3=NET_RX,4=BLOCK,5=TASKLET,6=SCHED,7=HRTIMER,8=RCU
> 
> Introducing new, elaborate description languages is always risky. 
> Would there be a way to reuse something existing - ideally some nice 
> sub-set of C structure definitions?

I'm open for suggestions. Yeah, I was trying to avoid the new markup, but 
C is more for code and not for printing. In fact C sucks for text markup 
:-(

But I would also like to avoid a full xml parser in the kernel ;-)

> 
> Also, would it be possible to put more newlines into the format, so 
> that human inspection is more straightforward. It wont matter to the 
> tools.

Actually, you can add newlines in the tags, and they will not affect the 
mark up. Well, at least before the numbers. You can have:

<sym:vec:
  0=HI,
  1=TIMER,
  2=NET_TX,
  3=NET_RX,
  4=BLOCK,
  5=TASKLET,
  6=SCHED,
  7=HRTIMER,
  8=RCU>

But actually, this would make it harder on the tools. Since currently my 
tool just reads one entire line. But I guess I can fix that too.

-- Steve

