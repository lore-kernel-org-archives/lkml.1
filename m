Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbZHBUmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbZHBUmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZHBUmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:42:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44915 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbZHBUmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:42:09 -0400
Date: Sun, 2 Aug 2009 22:41:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/debug] debug lockups: Improve lockup detection
Message-ID: <20090802204150.GB3986@elte.hu>
References: <tip-c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc@git.kernel.org> <20090802114545.f1520c81.akpm@linux-foundation.org> <20090802192657.GA21882@elte.hu> <20090802123958.cbd497a0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802123958.cbd497a0.akpm@linux-foundation.org>
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

> On Sun, 2 Aug 2009 21:26:57 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > I think this just broke all non-x86 non-sparc SMP architectures.
> > 
> > Yeah - it 'broke' them in the sense of them not having a working 
> > trigger_all_cpu_backtrace() implementation to begin with.
> 
> c'mon.  It broke them in the sense that sysrq-l went from "works" 
> to "doesn't work".

You are right (i broke it with my patch) but the thing is, sysrq-l 
almost useless currently: it uses schedule_work() which assumes a 
mostly working system with full irqs and scheduling working fine. 
Now, i dont need sysrq-l on mostly working systems.

So the 'breakage' is of something that was largely useless: and now 
you put the onus of implementing it for _all_ architectures (which i 
dont use) on me?

If that's the requirement then i'll have to keep this as a local 
debug hack and not do an upstream solution - i dont have the 
resources to do it for all ~10 SMP architectures.

sysrq-l has been messed up really and now that messup limits the 
adoption of the much more useful solution? I didnt make this thing 
up, i tried to use it on a locked up system and wondered why it 
emits nothing and why it uses a separate facility instead of an 
existing trigger-backtraces facility (which the spinlock-debug code 
uses).

> It would take months for the relevant arch maintainers to even 
> find out about this, after which they're left with dud kernels out 
> in the field.
> 
> It's better to break the build or to emit warnings than to 
> silently and secretly break their stuff.

But that warning will bounce the ball back to me, wont it? My patch 
will be blamed for 'breaking' those architectures, right?

	Ingo
