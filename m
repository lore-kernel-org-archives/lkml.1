Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYH0IDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYH0IDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYH0IDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:03:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbYH0IDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:03:01 -0400
Date: Wed, 27 Aug 2008 10:02:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: printk_time to use tsc before cpu_clock is ready
Message-ID: <20080827080238.GC4453@elte.hu>
References: <1219822736-18628-1-git-send-email-yhlu.kernel@gmail.com> <1219822736-18628-2-git-send-email-yhlu.kernel@gmail.com> <20080827074230.GA20993@elte.hu> <1219823233.6462.38.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219823233.6462.38.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2008-08-27 at 09:42 +0200, Ingo Molnar wrote:
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > 
> > > +static unsigned long long tsc_clock(int cpu)
> > > +{
> > > +	unsigned long long t;
> > > +
> > > +	rdtscll(t);
> > > +
> > > +	return t;
> > > +}
> > 
> > hm, i'm not sure i like the whole direction - this reintroduces 
> > printk_clock in essence.
> > 
> > how about initializing cpu_clock() sooner, so that printk timestamps 
> > start ticking as soon as possible?
> 
> which will make some archs quite unhappy iirc, see those arm and ia64 
> bugs I caused the other day.

that's OK - that still allows arches to start their clocks whenever they 
want to. But also add the possibility for architectures to initialize 
things even sooner.

	Ingo
