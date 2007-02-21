Return-Path: <linux-kernel-owner+w=401wt.eu-S1423279AbXBUXfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423279AbXBUXfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423278AbXBUXfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:35:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50193 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423279AbXBUXft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:35:49 -0500
Date: Thu, 22 Feb 2007 00:31:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070221233111.GB5895@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael K. Edwards <medwards.linux@gmail.com> wrote:

> 4) AIO vsyscalls whose semantics resemble those of IEEE 754 floating 
> point operations, with a clear distinction between a) pipeline state 
> vs. operands, b) results vs. side effects, and c) coding errors vs. 
> not-a-number results vs. exceptions that cost you a pipeline flush and 
> nonlocal branch.

threadlets (and syslets) are parallel contexts and they behave so - 
queuing and execution semantics are then ontop of that, implemented 
either by glibc, or implemented by the application. There is no 
'pipeline' of requests imposed - the structure of pending requests is 
totally free-form. For example in threadlet-test.c i've in essence 
implemented a 'set of requests' with the submission site only interested 
in whether all requests are done or not - but any stricter (or even 
looser) semantics and ordering can be used too.

in terms of AIO, the best queueing model is i think what the kernel uses 
internally: freely ordered, with barrier support. (That is equivalent to 
a "queue of sets", where the queue are the barriers, and the sets are 
the requests within barriers. If there is no barrier pending then 
there's just one large freely-ordered set of requests.)

	Ingo
