Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbZFIU6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbZFIU6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 16:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZFIU56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 16:57:58 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:44466 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbZFIU55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 16:57:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAB5cLkpMQW1W/2dsb2JhbACBT887hAoF
Date: Tue, 9 Jun 2009 16:01:59 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 2/5] tracing/events: nicer print format for parsing
Message-ID: <20090609200159.GA30713@Krystal>
References: <20090609014534.790466803@goodmis.org> <20090609014746.481457542@goodmis.org> <20090609192159.GD6057@nowhere> <alpine.DEB.2.00.0906091531090.30552@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906091531090.30552@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:00:36 up 101 days, 16:26,  5 users,  load average: 1.36, 0.50,
	0.30
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:

> Again, anyone have any better ideas?
> 
> -- Steve
> 

Hi Steven,

sorry I don't have much time to look into this. My ph.d. thesis is due
for july 5th..

I just wanted to let you now that I wrote a very simple XML parser in
the early days of LTTng. I dumped it in favor of the trace_mark() format
strings, but it really gave much more flexibility to describe events,
including nested structures, unions... etc.

It's written in C with almost no external dependency. The goal was to
make it so it could be acceptable in the kernel tree. I think you might
want to have a quick look at it. It generated the probe callbacks which
were, at the time, inlines. Since then I realised that inlining the
tracer code in the kernel call site pollutes the i-cache, so it's not
the way I would deal with code generation today, but those are minor
details.

It would need a cleanup. I did not write the original version of this
code, but rather kicked it until it worked as I wanted it. It worked
with the old LTTng versions:

http://www.lttng.org/files/packages/genevent-0.35.tar.gz

The package contains sample XML files.

Good luck,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
