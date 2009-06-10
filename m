Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbZFJMrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbZFJMrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbZFJMrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:47:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55421 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbZFJMrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:47:15 -0400
Date: Wed, 10 Jun 2009 08:47:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Hellwig <hch@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 2/5] tracing/events: nicer print format for parsing
In-Reply-To: <20090610094819.GA25527@infradead.org>
Message-ID: <alpine.DEB.2.00.0906100840410.30552@gandalf.stny.rr.com>
References: <20090609014534.790466803@goodmis.org> <20090609014746.481457542@goodmis.org> <20090609192159.GD6057@nowhere> <20090610094819.GA25527@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Christoph Hellwig wrote:

> On Tue, Jun 09, 2009 at 09:22:01PM +0200, Frederic Weisbecker wrote:
> > But I wonder if the above new language is not breaking the charm
> > of the TRACE_EVENT(), which charm is that it's easy to implement (hopefully).
> > 
> > Everyone knows the printk formats. And I guess this new thing is easy and
> > quick to learn. But because it's a new unknown language, the TRACE_EVENT
> > will become less readable, less reachable for newcomers in TRACE_EVENT.
> 
> I must also say I don't particularly like it.  printk is nice and easy
> an everybody knows it, but it's not quite flexible enough as we might
> have to do all kinds of conversions on the reader side.  What might be
> a better idea is to just have C function pointer for output conversions
> that could be put into the a file in debugfs and used by the binary
> trace buffer reader.  Or maybe not as we would pull in too many
> depenencies.

Yeah, having a printk function in debugfs that is controlled by the kernel
sounds wrong on so many levels ;-)

> 
> I think we should go with the printk solution for 2.6.31 and use the
> full development cycle for 2.6.32 to come up with something better.
> 
> As soon as a couple of large subsystems use the even tracer we also
> have a broader base examples to see how new syntax works on them.

Fair enough. I'm just worried that we'll start to get users that depend on 
the printk format. Perhaps the better idea is to remove the printk format 
from the debugfs format file, and force all tools to add their own for 
every event? At least until we can come up with a solution to dynamically do this?

-- Steve

