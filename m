Return-Path: <linux-kernel-owner+w=401wt.eu-S965082AbXCAO03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082AbXCAO03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965083AbXCAO03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:26:29 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:52385 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965082AbXCAO02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:26:28 -0500
Date: Thu, 1 Mar 2007 17:24:31 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20070301142430.GA25424@2ka.mipt.ru>
References: <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <20070301123423.GA10738@elte.hu> <20070301132626.GA30177@2ka.mipt.ru> <20070301133242.GA5477@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070301133242.GA5477@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 17:25:27 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 02:32:42PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > [...] that is why number for kevent is higher - it uses edge-triggered 
> > handler (which you asked to remove from epoll), [...]
> 
> no - i did not 'ask' it to be removed from epoll, i only pointed out 
> that with edge-triggered the results were highly unreliable here and 
> that with level-triggered it worked better. Just to make sure: if you 
> put back edge-triggered into evserver_epoll.c, do you get the same 
> numbers, and is CPU utilization still the same 98-100%?

No.
_Now_ it is about 1500-2000 req/sec with 10-20% CPU utilization. 
Number of 'Total transferred' and 'HTML transferred' does
not equal to 80000 multiplied by size of the page.

That are strange tests actually - I managed to get 9000 requests per
second from epoll server (only once!) and 8900 from kevent (two times
only), sometimes they both drop down to 2300-2700 req/s.

> 	Ingo

-- 
	Evgeniy Polyakov
