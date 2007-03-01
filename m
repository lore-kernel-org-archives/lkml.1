Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbXCAMmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbXCAMmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXCAMmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:42:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57651 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbXCAMmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:42:52 -0500
Date: Thu, 1 Mar 2007 13:34:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
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
Message-ID: <20070301123423.GA10738@elte.hu>
References: <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301105928.GA15709@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Document Length:        3521 bytes

> Concurrency Level:      8000
> Time taken for tests:   16.686737 seconds
> Complete requests:      80000
> Failed requests:        0
> Write errors:           0
> Total transferred:      309760000 bytes
> HTML transferred:       281680000 bytes
> Requests per second:    4794.23 [#/sec] (mean)

> Concurrency Level:      8000
> Time taken for tests:   12.366775 seconds
> Complete requests:      80000
> Failed requests:        0
> Write errors:           0
> Total transferred:      317047104 bytes
> HTML transferred:       288306522 bytes
> Requests per second:    6468.95 [#/sec] (mean)

i'm wondering - how can the 'Total transferred' and 'HTML transferred' 
numbers be different?

Since document length is 3521, and the number of requests is 80000, the 
correct 'HTML transferred' is 281680000 - which is the epoll result. The 
kevent result shows more bytes transferred, which suggests that the 
kevent loop is probably incorrect somewhere.

this might be some benign thing, but the /first/ thing you /have to/ do 
before claiming that 'kevent is 25% faster than epoll' is to make sure 
the results are totally reliable.

	Ingo
