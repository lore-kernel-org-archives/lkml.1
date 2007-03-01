Return-Path: <linux-kernel-owner+w=401wt.eu-S965155AbXCAO75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155AbXCAO75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965154AbXCAO74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:59:56 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:52949 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965155AbXCAO7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:59:55 -0500
Date: Thu, 1 Mar 2007 17:54:54 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301145454.GB12684@2ka.mipt.ru>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu> <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070301141637.GA20006@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 17:55:14 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 03:16:37PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > I can tell you that the problem (at least on my machine) comes from :
> > 
> > gettimeofday(&tm, NULL);
> > 
> > in evserver_epoll.c
> 
> yeah, that's another difference - especially if it's something like an 
> Athlon64 and gettimeofday falls back to pm-timer, that could explain the 
> performance difference. That's why i repeatedly asked Evgeniy to use the 
> /very same/ client function for both the epoll and the kevent test and 
> redo the measurements. The numbers are still highly suspect - and we are 
> already down from the prior claim of kevent being almost twice as fast 
> to a 25% difference.

There is no gettimeofday() in the running code anymore, and it was
placed not in common server processing code btw.

Ingo, do you really think I will send mails with faked benchmarks? :))

Btw, there were never almost twice perfromance increase - epoll in my
tests always showed 4-5 thousands requests per second, kevent - up to 7
thausands.

That starts looking like ghost hunting, Ingo, you already said that
you do not see any need in kevent, have you changed your opinion on
that?

> 	Ingo

-- 
	Evgeniy Polyakov
