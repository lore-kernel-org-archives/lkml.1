Return-Path: <linux-kernel-owner+w=401wt.eu-S965469AbXCAR7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965469AbXCAR7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:59:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965470AbXCAR7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:59:05 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:50447 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965469AbXCAR7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:59:04 -0500
Date: Thu, 1 Mar 2007 20:56:44 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Lang <david.lang@digitalinsight.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
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
Message-ID: <20070301175643.GA20219@2ka.mipt.ru>
References: <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <Pine.LNX.4.63.0703010822560.23701@qynat.qvtvafvgr.pbz>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0703010822560.23701@qynat.qvtvafvgr.pbz>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 20:57:25 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 08:56:28AM -0800, David Lang (david.lang@digitalinsight.com) wrote:
> the ab numbers below do not seem that impressive to me, especially for such 
> stripped down server processes.
...
> client and server are dual opteron 252 with 8G of ram, running debian in 64 
> bit mode

Decrease your hardware setup in 2-4 times, leave only one apache process 
and try to get the same - we are not talking about how to create a
perfect web server, instead we try to focus possible problems in
epoll/kevent event driven logic.

Vanilla (epoll) lighttpd shows 4000-5000 requests per second in my setup (no logs).
Default mpm-apache2 with bunch of threads - about 8k req/s.
Default thttpd (disabled logging) - about 2k req/s

Btw, all your tests are network bound, try to decrease 
html page size to get actual event processing speed out of that machines.

-- 
	Evgeniy Polyakov
