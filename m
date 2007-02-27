Return-Path: <linux-kernel-owner+w=401wt.eu-S1751442AbXB0Ifi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbXB0Ifi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbXB0Ifh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:35:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48170 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbXB0IfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:35:09 -0500
Date: Tue, 27 Feb 2007 09:27:57 +0100
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
Message-ID: <20070227082757.GA23617@elte.hu>
References: <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070225213420.GA10195@elte.hu> <20070226104507.GA18470@elte.hu> <20070226114858.GA28836@elte.hu> <20070226122521.GA19039@2ka.mipt.ru> <20070226125054.GA6997@elte.hu> <20070226143201.GB31629@2ka.mipt.ru> <20070226202338.GA23357@elte.hu> <20070227081611.GB16295@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227081611.GB16295@2ka.mipt.ru>
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

> > > Enough, you say micro-thread design is superior - ok, that is your 
> > > point.
> > 
> > note that threadlets are not 'micro-threads'. A threadlet is more of 
> > an 'optional thread' (as i mentioned it earlier): whenever it does 
> > anything that makes it distinct from a plain function call, it's 
> > converted into a separate thread by the kernel. Otherwise it behaves 
> > like a plain function call and returns.
> 
> I know.
> But it is rare case for the most situations, when things do not block, 
> so I called it micro-thread, since it spawns a new thread (get from 
> preallocated pool) for parallel processing.

ugh. Because 'it spawns a new thread from a preallocated pool' you are 
arbitrarily renaming threadlets to 'micro-threads'?? The kernel could be 
using a transparent thread pool for ordinary pthread recycling itself 
(and will possibly do so in the future) - that does not make them a 
micro-thread one iota. So please stop calling them micro-threads, 
threadlets are a distinctly separate concept ...

( And i guess you should know it perfectly well from my past mails in
  this thread that i dont like micro-thread concepts at all, so are you
  perhaps calling threadlets 'micro-threads' intentionally, just to 
  force a predictably negative reaction from me? Maybe i should start 
  renaming your code too and refer to kevents as 'kpoll'? That too makes
  absolutely zero sense. This is getting really silly. )

	Ingo
