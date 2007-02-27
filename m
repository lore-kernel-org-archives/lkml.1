Return-Path: <linux-kernel-owner+w=401wt.eu-S1030591AbXB0Mqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591AbXB0Mqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 07:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030601AbXB0Mqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 07:46:31 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35970 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030591AbXB0Mqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 07:46:30 -0500
Date: Tue, 27 Feb 2007 15:40:27 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Theodore Tso <tytso@mit.edu>,
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
Message-ID: <20070227124026.GB20235@2ka.mipt.ru>
References: <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru> <20070227121328.GA18565@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070227121328.GA18565@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 27 Feb 2007 15:41:54 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 01:13:28PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > > [...]  But it is true that for most kernel programmers, threaded 
> > > programming is much easier to understand, and we need to engineer 
> > > the kernel for what will be maintainable for the majority of the 
> > > kernel development community.
> > 
> > I understand that - and I totally agree.
> 
> why did you then write, just one mail ago, the exact opposite:
> 
> > And debugging state machine code has exactly the same complexity as 
> > debugging multi-threading code - if not less...

Because thread machinery is much more complex than event one - just
compare amount of code in scheduler and the whole kevent -
kernel/sched.c has about the same size as the whole kevent :)

> the kernel /IS/ multi-threaded code.
> 
> which statement of yours is also patently, absurdly untrue. 
> Multithreaded code is harder to debug than process based code, but it is 
> still a breeze compared to complex state-machines...

It seems that we are talking about different levels.

Model I propose to use in userspace - very simple events mostly about
completion of the request - they are simple to use and simple to debug.
It can be slightly more hard to debug, than the simplest threading model
(one thread - one logical entity, which whould never work with others)
though.

>From userspace point of view it is about the same complexity to check
why event is not marked as ready, or why some thread never got
scheduled...
And we do not get into account possible synchronization methods needed
to run multithreaded code without problems.

> 	Ingo

-- 
	Evgeniy Polyakov
