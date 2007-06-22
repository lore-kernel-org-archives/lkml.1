Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbXFVN1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbXFVN1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbXFVN1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:27:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40015 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbXFVN1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:27:36 -0400
Date: Fri, 22 Jun 2007 15:26:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, johnstul@us.ibm.com, oleg@tv-sign.ru,
       paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com, davem@davemloft.net,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622132622.GA21130@elte.hu>
References: <20070622040014.234651401@goodmis.org> <20070622070948.GA21291@infradead.org> <1182515542.5493.20.camel@localhost.localdomain> <20070622123805.GA9770@elte.hu> <1182517124.5493.38.camel@localhost.localdomain> <20070622061326.2e2d6d15.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622061326.2e2d6d15.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> I do think that would be a better approach.  Apart from the 
> cleanliness issue, the driver-by-driver conversion would make it much 
> easier to hunt down any regresions or various funnineses.

there are 120 tasklet_init()s in the tree and 224 tasklet_schedule()s. 
Pushing it into thread context should work just fine (Steve's patchset 
certainly works on my testbox), as even today we can execute softirqs 
(and hence tasklets) in ksoftirqd. In fact, -rt has been executing 
tasklets in task context for over 2.5 years meanwhile. Do we really want 
to upset the whole API? Realistically it just wont ever be removed, like 
the BKL.

	Ingo
