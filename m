Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbZDWLwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbZDWLwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 07:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZDWLwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 07:52:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42230 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbZDWLv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 07:51:59 -0400
Subject: Re: [Patch] mm tracepoints update - use case.
From: Larry Woodman <lwoodman@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       =?UTF-8?Q?Fr=E9=A6=98=E9=A7=BBic?= Weisbecker 
	<fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, riel@redhat.com, rostedt@goodmis.org
In-Reply-To: <20090423084233.GF599@elte.hu>
References: <1240402037.4682.3.camel@dhcp47-138.lab.bos.redhat.com>
	 <1240428151.11613.46.camel@dhcp-100-19-198.bos.redhat.com>
	 <20090423092933.F6E9.A69D9226@jp.fujitsu.com>
	 <20090422215055.5be60685.akpm@linux-foundation.org>
	 <20090423084233.GF599@elte.hu>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 07:47:11 -0400
Message-Id: <1240487231.4682.27.camel@dhcp47-138.lab.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-23 at 10:42 +0200, Ingo Molnar wrote:

> 
> Not so in the usescases i made use of tracers. The key is not to 
> trace everything, but to have a few key _concepts_ traced 
> pervasively. Having a dynamic notion of a per event changes is also 
> obviously good. In a fast changing workload you cannot just tell 
> based on summary statistics whether rapid changes are the product of 
> the inherent entropy of the workload, or the result of the MM being 
> confused.
> 
> /proc/ statisitics versus good tracing is like the difference 
> between a magnifying glass and an electron microscope. Both have 
> their strengths, and they are best if used together.
> 
> One such conceptual thing in the scheduler is the lifetime of a 
> task, its schedule, deschedule and wakeup events. It can already 
> show a massive amount of badness in practice, and it only takes a 
> few tracepoints to do.
> 
> Same goes for the MM IMHO. Number of pages reclaimed is obviously a 
> key metric to follow. Larry is an expert who fixed a _lot_ of MM 
> crap in the last 5-10 years at Red Hat, so if he says that these 
> tracepoints are useful to him, we shouldnt just dismiss that 
> experience like that. I wish Larry spent some of his energies on 
> fixing the upstream MM too ;-)
> 
> A balanced number of MM tracepoints, showing the concepts and the 
> inner dynamics of the MM would be useful. We dont need every little 
> detail traced (we have the function tracer for that), but a few key 
> aspects would be nice to capture ...

I hear you, there is  lot of data coming out of these mm tracepoints as
well as must of the other tracepoints I've played around with, we have
to filter them.  I added them in locations that would allow us to debug
a variety of real running systems such as a Wall St. trading server
during the heaviest period of the day without rebooting a debug kernel.
We can collect whatever is needed to figure out whats happening then
turning it all off when we've collected enough.  We've seen systems
experiencing performance problems caused by the "inner'ds" of the page
reclaim code, memory leak problems cause by applications, excessive COW
faults caused by applications that mmap() gigs of files then fork and
applications that rely the kernel to flush out every modified page of
those gigs of mmap()'d file data every 30 seconds via kupdate because
other kernel do. The list goes on and on...  These tracepoints are in
the same locations that we've placed debug code in debug kernels in the
past.

Larry


 
> 
> pagefaults, allocations, cache-misses, cache flushes and how pages 
> shift between various queues in the MM would be a good start IMHO.
> 
> Anyway, i suspect your answer means a NAK :-( Would be nice if you 
> would suggest a path out of that NAK.
> 
> 	Ingo

