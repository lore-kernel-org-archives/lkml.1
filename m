Return-Path: <linux-kernel-owner+w=401wt.eu-S1751224AbXBZM1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbXBZM1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964965AbXBZM1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:27:52 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:34732 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbXBZM1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:27:51 -0500
Date: Mon, 26 Feb 2007 15:25:22 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: threadlets as 'naive pool of threads', epoll, some measurements
Message-ID: <20070226122521.GA19039@2ka.mipt.ru>
References: <20070225182135.GB29821@2ka.mipt.ru> <20070225182230.GA3622@elte.hu> <20070225183743.GD29821@2ka.mipt.ru> <20070225192112.GA15681@elte.hu> <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070225213420.GA10195@elte.hu> <20070226104507.GA18470@elte.hu> <20070226114858.GA28836@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070226114858.GA28836@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Mon, 26 Feb 2007 15:26:43 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 12:48:58PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> yet another performance update - with the fixed 'heaps of stupid 
> threads' evserver_threadlet.c code attached below i got:
> 
> >    evserver_epoll:             9400 reqs/sec
> >    evserver_epoll_threadlet:   9400 reqs/sec
> 
>      evserver_threadlet:         9000 reqs/sec
> 
> so the overhead, instead of the 10x slowdown Evgeniy predicted/feared, 
> is 4% for this particular, very event-centric workload.
> 
> why? because Evgeniy still overlooks what i've mentioned so many times: 
> that there is lots of inherent 'caching' possible even in this 
> particular '8000 clients' workload, which even the most stupid threadlet 
> queueing model is able to take advantage of. The maximum level of 
> parallelism that i've measured during this test was 161 threads.

:)

I feared _ONLY_ situation when thousands of thereads are eating my brain
- so case when 161 threads are running simultanesoulsy is not that bad
compared to what micro-design can do (of its best/worst) at all!

So, caching is good - threadlets do not spawn a new thread, kevent
returns immediately, but in case of things are not that shine -
threadlets spawnd a new thread, while kevent process next request or
waits for all completed.

I'm a bit stuck right now with my benchmarks - intel core2 machine
requires reinstallation (it is installed for amd64 arch of debian
testing and admins at paid work setup my internet connection
down to miserable bytes per second (who said that hacked/social
engineered 1mb/sec can live forever?), so expect it tomorrow), 
via epia one is under stress testing right now.

> 	Ingo

-- 
	Evgeniy Polyakov
