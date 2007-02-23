Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbXBWM0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbXBWM0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 07:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932296AbXBWM0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 07:26:05 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:42938 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbXBWM0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 07:26:04 -0500
Date: Fri, 23 Feb 2007 15:22:25 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070223122224.GB5392@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru> <20070223115152.GA2565@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070223115152.GA2565@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 23 Feb 2007 15:23:21 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 12:51:52PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > [...] Those 20k blocked requests were created in about 20 seconds, so 
> > roughly saying we have 1k of thread creation/freeing per second - do 
> > we want this?
> 
> i'm not sure why you mention thread creation and freeing. The 
> syslet/threadlet code reuses already created async threads, and that is 
> visible all around in both the kernel-space and in the user-space 
> syslet/threadlet code.
> 
> While Linux creates+destroys threads pretty damn fast (in about 10-15 
> usecs - which is roughly the cost of getting a single 1-byte packet 
> through a TCP socket from one process to another, on localhost), still 
> we dont want to create and destroy a thread per request.

I meant that we end up with having one thread per IO - they were
preallocated, but that does not matter. And what about your idea of
switching userspace threads to cachemiss threads?

My main concern was only about the situation, when we ends up with truly
bloking context (like network), and this results in having thousands of
threads doing the work - even having most of them sleeping, there is a
problem with memory overhead and context switching, although it is usable
situation, but when all of them are ready immediately - context switching 
will kill a machine even with O(1) scheduler which made situation damn
better than before, but it is not a cure for the problem.

> 	Ingo

-- 
	Evgeniy Polyakov
