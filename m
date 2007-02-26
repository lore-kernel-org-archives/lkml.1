Return-Path: <linux-kernel-owner+w=401wt.eu-S1030187AbXBZKpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030187AbXBZKpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030192AbXBZKpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:45:18 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33851 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030187AbXBZKpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:45:16 -0500
Date: Mon, 26 Feb 2007 13:43:02 +0300
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
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226104302.GB24284@2ka.mipt.ru>
References: <20070225182230.GA3622@elte.hu> <20070225183743.GD29821@2ka.mipt.ru> <20070225192112.GA15681@elte.hu> <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070226081655.GA25280@elte.hu> <20070226092545.GA4110@2ka.mipt.ru> <20070226095547.GA9485@elte.hu> <20070226103117.GA16101@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070226103117.GA16101@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Mon, 26 Feb 2007 13:44:21 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 11:31:17AM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > please also try evserver_epoll_threadlet.c that i've attached below - 
> > it uses epoll as the main event mechanism but does threadlets for 
> > request handling.
> 
> find updated code below - your evserver_epoll.c spuriously missed event 
> edges - so i changed it back to level-triggered. While that is not as 
> fast as edge-triggered, it does not result in spurious hangs and 
> workflow 'hickups' during the test.

Hmm, exact the same evserver_epoll.c you downloaded works ok for me,
although yes, it is buggy in that regard that it does not contain socket
close when data is transferred.

> Could this be the reason why in your testing kevents outperformed epoll?

I will try to check. In theory without _ET it should perfoem much worse,
but in practice its performance is essentially the same (the same applies 
to kevent without KEVENT_REQ_ET flag - since the same socket almost never 
is used several times, it is purely zero overhead to have or not have that 
flag set).

> Also, i have removed the set-nonblocking calls because they are not 
> needed under threadlets.
> 
> [ to build this code, copy it into the async-test/ directory and build
>   it there - or copy the *.h files from async-test/ directory into your
>   build directory. ]

Ok, right now I'm compiling kevent/threadlet tree on my test machines.

> 	Ingo

-- 
	Evgeniy Polyakov
