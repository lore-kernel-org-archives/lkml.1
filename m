Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbZFINIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbZFINIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbZFINIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:08:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59541 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbZFINID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:08:03 -0400
Date: Tue, 9 Jun 2009 09:08:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 5/5] tracing/events: modify kmem print to new
 format
In-Reply-To: <20090609080656.GB18380@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0906090907110.17452@gandalf.stny.rr.com>
References: <20090609014534.790466803@goodmis.org> <20090609014747.188279837@goodmis.org> <1244531562.13761.9955.camel@twins> <20090609080656.GB18380@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Jun 2009, Mel Gorman wrote:

> On Tue, Jun 09, 2009 at 09:12:42AM +0200, Peter Zijlstra wrote:
> > On Mon, 2009-06-08 at 21:45 -0400, Steven Rostedt wrote:
> > 
> > > +#define show_gfp_flags(end...)						\
> > > +	"0=GFP_NOWAIT,"							\
> > > +	"0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s," \
> > > +	"0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s," \
> > > +	"0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s,0x%lx=%s," \
> > > +	"0x%lx=%s,0x%lx=%s>" end ,					\
> > > +	(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE", \
> > > +	(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER",		\
> > > +	(unsigned long)GFP_USER,		"GFP_USER",		\
> > > +	(unsigned long)GFP_TEMPORARY,		"GFP_TEMPORARY",	\
> > > +	(unsigned long)GFP_KERNEL,		"GFP_KERNEL",		\
> > > +	(unsigned long)GFP_NOFS,		"GFP_NOFS",		\
> > > +	(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC",		\
> > > +	(unsigned long)GFP_NOIO,		"GFP_NOIO",		\
> > > +	(unsigned long)__GFP_HIGH,		"GFP_HIGH",		\
> > > +	(unsigned long)__GFP_WAIT,		"GFP_WAIT",		\
> > > +	(unsigned long)__GFP_IO,		"GFP_IO",		\
> > > +	(unsigned long)__GFP_COLD,		"GFP_COLD",		\
> > > +	(unsigned long)__GFP_NOWARN,		"GFP_NOWARN",		\
> > > +	(unsigned long)__GFP_REPEAT,		"GFP_REPEAT",		\
> > > +	(unsigned long)__GFP_NOFAIL,		"GFP_NOFAIL",		\
> > > +	(unsigned long)__GFP_NORETRY,		"GFP_NORETRY",		\
> > > +	(unsigned long)__GFP_COMP,		"GFP_COMP",		\
> > > +	(unsigned long)__GFP_ZERO,		"GFP_ZERO",		\
> > > +	(unsigned long)__GFP_NOMEMALLOC,	"GFP_NOMEMALLOC",	\
> > > +	(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL",		\
> > > +	(unsigned long)__GFP_THISNODE,		"GFP_THISNODE",		\
> > > +	(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE",	\
> > > +	(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"
> > 
> > Just curious, how unhappy does stuff become when we add a __GFP_ flag
> > and forget to extend this table?
> > 
> 
> If it's the same behaviour as what I was looking at yesterday, it prints
> the remaining flags it doesn't recognise as the number.
> 
> GFP_KERNEL|__GFP_DMA got outputted as |GFP_KERNEL|0x1|

Yep, that is what would happen here too.

Any comments on this approach? I'll go ahead and start fixing it up more 
(handling all the memory freeing on errors) and get it ready to push out.

-- Steve

