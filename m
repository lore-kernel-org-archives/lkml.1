Return-Path: <linux-kernel-owner+w=401wt.eu-S1161016AbXBZUbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161016AbXBZUbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161022AbXBZUbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:31:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39317 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161016AbXBZUbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:31:32 -0500
Date: Mon, 26 Feb 2007 21:23:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
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
Subject: Re: threadlets as 'naive pool of threads', epoll, some measurements
Message-ID: <20070226202338.GA23357@elte.hu>
References: <20070225192112.GA15681@elte.hu> <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070225213420.GA10195@elte.hu> <20070226104507.GA18470@elte.hu> <20070226114858.GA28836@elte.hu> <20070226122521.GA19039@2ka.mipt.ru> <20070226125054.GA6997@elte.hu> <20070226143201.GB31629@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226143201.GB31629@2ka.mipt.ru>
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

> > no. Please read the evserver_threadlet.c code. There's no kevent in 
> > there. There's no epoll() in there. All that you can see there is 
> > the natural behavior of pure threadlets. And it's not a workload /I/ 
> > picked for threadlets - it is a workload, filesize, parallelism 
> > level and request handling function /you/ picked for 
> > "event-servers".
> 
> I know that there is no kevents there, that would be really strange if 
> you would test it in your environment after all that empty kevent 
> releases.

i havent got around figuring out the last v2.6.20 based kevent release, 
and your git tree is v2.6.21-rc1 based. Do you have some easy URL for me 
to fetch the last v2.6.20 kevent release?

> Enough, you say micro-thread design is superior - ok, that is your 
> point.

note that threadlets are not 'micro-threads'. A threadlet is more of an 
'optional thread' (as i mentioned it earlier): whenever it does anything 
that makes it distinct from a plain function call, it's converted into a 
separate thread by the kernel. Otherwise it behaves like a plain 
function call and returns.

	Ingo
