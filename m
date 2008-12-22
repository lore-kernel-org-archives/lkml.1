Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbYLVJGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbYLVJGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 04:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYLVJF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 04:05:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbYLVJF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 04:05:56 -0500
Date: Mon, 22 Dec 2008 10:05:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimer: increase clock min delta threshold while
	interrupt hanging
Message-ID: <20081222090545.GA2064@elte.hu>
References: <494EEC60.4080708@gmail.com> <200812220307.16808.elendil@planet.nl> <20081222070044.GC29160@elte.hu> <c62985530812220100m775c2e5ek5889f7891e4c1f4d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812220100m775c2e5ek5889f7891e4c1f4d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> > Also, there's min_delta doubling in tick_dev_program_event() itself 
> > too - that interacts with the irq-overload logic:
> >
> > +       dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;
> >
> >        Ingo
> 
> That's what I explained above, the doubling of min delta in 
> tick_dev_program_event() is never reached in my case. And moreover I'm 
> not sure it is ever reached whatever the call sites of 
> tick_dev_program_event() unless min delta has a very low value...

yeah, that looks all rather messy and probably ineffective. Thomas, mind 
to take a look?

Frederic's patch solves a real timer-irq-overload extreme situation so i 
find it rather valuable. Maybe we should do Frederic's patch as-is, have 
the 'softer' min_delta behavior for the usual hrtimer codepaths - and the 
more agressive one for the timer tick only?

	Ingo
