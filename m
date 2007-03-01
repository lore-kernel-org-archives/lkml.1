Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbXCAOYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbXCAOYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXCAOYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:24:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51886 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbXCAOYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:24:46 -0500
Date: Thu, 1 Mar 2007 15:16:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Pavel Machek <pavel@ucw.cz>,
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
Message-ID: <20070301141637.GA20006@elte.hu>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu> <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703011519.20001.dada1@cosmosbay.com>
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


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> I can tell you that the problem (at least on my machine) comes from :
> 
> gettimeofday(&tm, NULL);
> 
> in evserver_epoll.c

yeah, that's another difference - especially if it's something like an 
Athlon64 and gettimeofday falls back to pm-timer, that could explain the 
performance difference. That's why i repeatedly asked Evgeniy to use the 
/very same/ client function for both the epoll and the kevent test and 
redo the measurements. The numbers are still highly suspect - and we are 
already down from the prior claim of kevent being almost twice as fast 
to a 25% difference.

	Ingo
