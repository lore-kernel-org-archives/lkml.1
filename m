Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbXFVXBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbXFVXBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXFVXAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:00:52 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:40416 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXFVXAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:00:51 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622215953.GA22917@elte.hu>
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 18:58:50 -0400
Message-Id: <1182553130.5493.105.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 23:59 +0200, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > If the numbers say that there is no performance difference (or even 
> > better: that the new code performs better or fixes some latency issue 
> > or whatever), I'll be very happy. But if the numbers say that it's 
> > worse, no amount of cleanliness really changes that.
> 
> Most of the tasklet uses are in rarely used or arcane drivers - in fact 
> none of my 10 test-boxes utilizes _any_ tasklet in any way that could 
> even get close to mattering to performance. In other words: i just 
> cannot test this, nor do i think that others will really test this. 

This is exactly why I included that CONFIG option in the first series.
Because, I only have a handful of hardware that actually uses tasklets.
And all those pr_debugs I had where turned on on most of my boxes.  I
was not flooded with prints either (every function including
tasklet_schedule had a print).

So, basically, I can't do benchmarks. I was hoping to get this into -mm
with a easy way for people, who have hardware that uses tasklets
extensively, to run it with tasklets on and off to see if there is a
difference.  My fear of not having a config option to switch between the
two (for -mm only) is that we may lose benchmarking from those that are
not comfortable at removing this patch from -mm.  There are people out
there that download and test the -mm tree straight from kernel.org.
Just because someone compiles their own kernel doesn't mean they can (or
will) patch it.

-- Steve



