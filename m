Return-Path: <linux-kernel-owner+w=401wt.eu-S933252AbXCALtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbXCALtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933253AbXCALtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:49:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34640 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252AbXCALtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:49:23 -0500
Date: Thu, 1 Mar 2007 12:41:37 +0100
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
Message-ID: <20070301114137.GB897@elte.hu>
References: <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <20070301110022.GA28260@elte.hu> <20070301111629.GA27381@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301111629.GA27381@2ka.mipt.ru>
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

> I also changed client socket to nonblocking mode with the same result 
> in epoll server. If you will find it broken, please send me corrected 
> to test too.

this line in evserver_kevent.c looks a bit fishy:

        err = recv(s, buf, 100, 0);

because on the evserver_epoll.c side the following is done:

        err = recv(s, buf, 4096, 0);

now, for 'ab', the request size is 76 bytes, so it should fit fine 
functionality-wise. But, the TCP stack might decide differently of 
whether to return with a partial packet depending on how much data is 
requested. I dont know whether it actually makes a difference in the TCP 
flow decisions, and whether it makes a performance difference in your 
test, but safest would be to use 4096 in both cases.

in general, please make sure the exact same system calls are done in the 
client function. (except of course for the event queueing syscalls 
themselves)

	Ingo
