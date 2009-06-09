Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbZFIWq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbZFIWq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbZFIWqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:46:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65036 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbZFIWqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:46:49 -0400
Date: Tue, 9 Jun 2009 18:46:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 4/8] tracing/events: modify irq print to new format
In-Reply-To: <20090609222217.GE6057@nowhere>
Message-ID: <alpine.DEB.2.00.0906091846010.30552@gandalf.stny.rr.com>
References: <20090609215211.307980196@goodmis.org> <20090609215339.384594898@goodmis.org> <20090609222217.GE6057@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Frederic Weisbecker wrote:
> >  
> >  /**
> > @@ -106,8 +106,8 @@ TRACE_EVENT(softirq_entry,
> >  		__entry->vec = (int)(h - vec);
> >  	),
> >  
> > -	TP_printk("softirq=%d action=%s", __entry->vec,
> > -		  show_softirq_name(__entry->vec))
> > +	TP_FORMAT("softirq=<int:vec> action=<sym:vec:" show_softirq_name_format(),
> 
> 
> Just to zap the confusion, I would suggest to explicitly close the '>' here instead
> of inside the macro. The current state suggests a kind of imbalance at a first glance.
> 
> 
> > +		  show_softirq_name_args())
> >  );
> >  
> >  /**
> > @@ -135,8 +135,8 @@ TRACE_EVENT(softirq_exit,
> >  		__entry->vec = (int)(h - vec);
> >  	),
> >  
> > -	TP_printk("softirq=%d action=%s", __entry->vec,
> > -		  show_softirq_name(__entry->vec))
> > +	TP_FORMAT("softirq=<int:vec> action=<sym:vec:" show_softirq_name_format(),
> 
> 
> And ditto.
> 

Ah, yeah right. Now that I have the formats separated, I can do that. The 
first patch had it as one (format and args). I'll add a separate patch in 
my next set of patches that build on top of this one.

-- Steve

