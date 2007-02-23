Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbXBWMSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbXBWMSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 07:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932276AbXBWMSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 07:18:36 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:54021 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281AbXBWMSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 07:18:30 -0500
Date: Fri, 23 Feb 2007 15:15:22 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070223121521.GA5392@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru> <Pine.LNX.4.64.0702221139320.1356@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702221139320.1356@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 23 Feb 2007 15:16:11 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 11:46:48AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> > I tried already :) - I just made a allocations atomic in tcp_sendmsg() and
> > ended up with 1/4 of the sends blocking (I counted both allocation
> > failure and socket queue overflow). Those 20k blocked requests were
> > created in about 20 seconds, so roughly saying we have 1k of thread
> > creation/freeing per second - do we want this?
> 
> A dynamic pool will smooth thread creation/freeing up by a lot.
> And, in my box a *pthread* create/free takes ~10us, at 1000/s is 10ms, 1%. 
> Bad, but not so aweful ;)
> Look, I'm *definitely* not trying to advocate the use of async syscalls for 
> network here, just pointing out that when we're talking about threads, 
> Linux does a pretty good job.
 
If we are going to create 1000 threads each second, then it is better to
preallocate them and queue a work to that pool - like syslets did with
syscalls, but not ulitimately create a new thread just because it is not 
that slow.

All such micro-thread designs are especially good in the case when 
1. switching is _rare_ (very)
2. programmer does not want to create complex model to achieve maximum
performance

Disk (cached) IO definitely hits first entry and second one is there for
advertisements and fast deployment, but overall usage of the
asynchronous IO model is not limited to the above scenario, so
micro-threads definitely hit own niche, but they can not cover all usage
cases.
 
> 
> - Davide
> 

-- 
	Evgeniy Polyakov
