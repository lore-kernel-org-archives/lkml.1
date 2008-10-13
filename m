Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbYJMQW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbYJMQW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbYJMQWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:22:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43963 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442AbYJMQWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:22:17 -0400
Date: Mon, 13 Oct 2008 18:21:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Karel Zak <kzak@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
	"hwclock" program
Message-ID: <20081013162157.GA32355@elte.hu>
References: <20081004215225.2444d54b.akpm@linux-foundation.org> <20081005081145.30ba921b@infradead.org> <20081005102742.de8353b4.akpm@linux-foundation.org> <20081005103826.6771540a@infradead.org> <20081012200004.GI10429@nb.net.home> <alpine.LFD.2.00.0810121308210.3402@nehalem.linux-foundation.org> <20081013152633.GA6523@elte.hu> <alpine.LFD.2.00.0810130841440.3288@nehalem.linux-foundation.org> <20081013160259.GA26866@elte.hu> <alpine.LFD.2.00.0810130908150.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810130908150.3288@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > It's probably not a real issue in practice because this is about PID 
> > 1, so i doubt it really matters, but still.
> > 
> > So how about the patch below?
> 
> Ack. As long as we don't have two versions and the code is impossible 
> to look at.

thx, added your Acked-by and queued it up in x86/urgent.

The many dumb #ifdefs were the result of the mechanic unification of 
fault.c - we waited for the bugs to get shaken out - it went pretty 
well, there was only one in the end IIRC.

Now we can unify it semantically as well and create sane, maintainable 
code with gradual patches. We used to have over 50 #ifdefs in fault.c 
iirc, that's now down to 24. (still high but shrinking)

	Ingo
