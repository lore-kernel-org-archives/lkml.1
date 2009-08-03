Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbZHCIAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbZHCIAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbZHCIAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:00:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51092 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbZHCIAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:00:04 -0400
Date: Mon, 3 Aug 2009 09:59:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/debug] debug lockups: Improve lockup detection
Message-ID: <20090803075943.GA32258@elte.hu>
References: <tip-c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc@git.kernel.org> <20090802114545.f1520c81.akpm@linux-foundation.org> <20090802192657.GA21882@elte.hu> <20090802123958.cbd497a0.akpm@linux-foundation.org> <20090802204150.GB3986@elte.hu> <20090802140809.7ec4bb6b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802140809.7ec4bb6b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 2 Aug 2009 22:41:50 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Sun, 2 Aug 2009 21:26:57 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > > I think this just broke all non-x86 non-sparc SMP architectures.
> > > > 
> > > > Yeah - it 'broke' them in the sense of them not having a working 
> > > > trigger_all_cpu_backtrace() implementation to begin with.
> > > 
> > > c'mon.  It broke them in the sense that sysrq-l went from "works" 
> > > to "doesn't work".
> > 
> > You are right (i broke it with my patch) but the thing is, 
> > sysrq-l almost useless currently: it uses schedule_work() which 
> > assumes a mostly working system with full irqs and scheduling 
> > working fine. Now, i dont need sysrq-l on mostly working 
> > systems.
> > 
> > So the 'breakage' is of something that was largely useless: and 
> > now you put the onus of implementing it for _all_ architectures 
> > (which i dont use) on me?
> 
> I never said that.
>
> It's appropriate that those architectures be left with their 
> existing level of functionality/usefulness, as you're already 
> discussing.

Ok, agreed.

> > > It's better to break the build or to emit warnings than to 
> > > silently and secretly break their stuff.
> > 
> > But that warning will bounce the ball back to me, wont it? My 
> > patch will be blamed for 'breaking' those architectures, right?
> 
> It's a very crude and somewhat rude way of communicating 
> information to other architecture maintainers.
>
> A better way would be to send them an email explaining the problem 
> and outlining some solutions, no?

I've restored the generic fallback code so there should be no change 
in functionality. I'll test it and push it out - you can check that 
patch via the commit notification email.

Thanks,

	Ingo
