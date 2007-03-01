Return-Path: <linux-kernel-owner+w=401wt.eu-S965141AbXCAOz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141AbXCAOz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXCAOz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:55:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41597 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965141AbXCAOzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:55:25 -0500
Date: Thu, 1 Mar 2007 15:47:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
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
Message-ID: <20070301144717.GA24079@elte.hu>
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <200703011228.01144.dada1@cosmosbay.com> <20070301114731.GA20773@2ka.mipt.ru> <200703011412.51256.dada1@cosmosbay.com> <20070301144350.GA12684@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301144350.GA12684@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> CPU: AMD64 processors, speed 2210.08 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a unit mask of 0x00 (No unit mask) count 100000
> samples  %        symbol name
> 195750   67.3097  cpu_idle
> 14111     4.8521  enter_idle
> 4979      1.7121  IRQ0x51_interrupt
> 4765      1.6385  tcp_v4_rcv

the pretty much only meaningful way to measure this is to:

- start a really long 'ab' testrun. Something like "ab -c 8000 -t 600".
- let the system get into 'steady state': i.e. CPU load at 100%
- reset the oprofile counters, then start an oprofile run for 60 
  seconds.
- stop the oprofile run.
- stop the test.

this way there wont be that many 'cpu_idle' entries in your profiles, 
and the profiles between the two event delivery mechanisms will be 
directly comparable.

> In that tests I got epoll perf about 4400 req/s, kevent was about 
> 5300.

So we are now up to epoll being 83% of kevent's performance - while the 
noise of numbers seen today alone is around 100% ... Could you update 
the files two URLs that you posted before, with the code that you used 
for the above numbers:

   http://tservice.net.ru/~s0mbre/archive/kevent/evserver_epoll.c
   http://tservice.net.ru/~s0mbre/archive/kevent/evserver_kevent.c

thanks,

	Ingo
