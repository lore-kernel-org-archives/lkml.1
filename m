Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527AbXB0IXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbXB0IXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXB0IXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:23:32 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:45095 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbXB0IXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:23:31 -0500
Date: Tue, 27 Feb 2007 11:16:11 +0300
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
Message-ID: <20070227081611.GB16295@2ka.mipt.ru>
References: <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070225213420.GA10195@elte.hu> <20070226104507.GA18470@elte.hu> <20070226114858.GA28836@elte.hu> <20070226122521.GA19039@2ka.mipt.ru> <20070226125054.GA6997@elte.hu> <20070226143201.GB31629@2ka.mipt.ru> <20070226202338.GA23357@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070226202338.GA23357@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 27 Feb 2007 11:17:05 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 09:23:38PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > > no. Please read the evserver_threadlet.c code. There's no kevent in 
> > > there. There's no epoll() in there. All that you can see there is 
> > > the natural behavior of pure threadlets. And it's not a workload /I/ 
> > > picked for threadlets - it is a workload, filesize, parallelism 
> > > level and request handling function /you/ picked for 
> > > "event-servers".
> > 
> > I know that there is no kevents there, that would be really strange if 
> > you would test it in your environment after all that empty kevent 
> > releases.
> 
> i havent got around figuring out the last v2.6.20 based kevent release, 
> and your git tree is v2.6.21-rc1 based. Do you have some easy URL for me 
> to fetch the last v2.6.20 kevent release?

I use kevent-36 release patches on top of 2.6.20 tree.
There are some syscall numbers overlap with thrteadlet patches, but
rejectsa re trivial.

> > Enough, you say micro-thread design is superior - ok, that is your 
> > point.
> 
> note that threadlets are not 'micro-threads'. A threadlet is more of an 
> 'optional thread' (as i mentioned it earlier): whenever it does anything 
> that makes it distinct from a plain function call, it's converted into a 
> separate thread by the kernel. Otherwise it behaves like a plain 
> function call and returns.

I know.
But it is rare case for the most situations, when things do not block,
so I called it micro-thread, since it spawns a new thread (get from
preallocated pool) for parallel processing.

> 	Ingo

-- 
	Evgeniy Polyakov
