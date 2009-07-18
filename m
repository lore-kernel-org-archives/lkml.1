Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbZGRMPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbZGRMPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 08:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZGRMPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 08:15:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55611 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZGRMPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 08:15:13 -0400
Date: Sat, 18 Jul 2009 14:14:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave <kilroyd@googlemail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] check spinlock_t/rwlock_t argument type on non-SMP
	builds
Message-ID: <20090718121413.GE31007@elte.hu>
References: <1246560291-8104-1-git-send-email-kilroyd@googlemail.com> <20090703073801.GA10191@elte.hu> <4A4E55A9.7090001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4E55A9.7090001@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Dave <kilroyd@googlemail.com> wrote:

> Ingo Molnar wrote:
> > * David Kilroy <kilroyd@googlemail.com> wrote:
> > 
> >> When writing code for UP without CONFIG_DEBUG_SPINLOCK it's easy 
> >> to get the first argument to the spinlock/rwlock functions wrong. 
> >> This is because the parameter is not actually used in this 
> >> configuration.
> >>
> >> Typically you will only find out it's wrong
> >>  * by rebuilding with CONFIG_SMP or CONFIG_DEBUG_SPINLOCK
> >>  * after you've submitted your beautiful patch series.
> >>
> >> The first means a long wait, and the latter is a bit late.
> >>
> >> Add typechecking on the first argument of these macro functions. 
> >> Note that since the typecheck now references the variable, the 
> >> explicit read is redundant and can be removed.
> >>
> >> This change causes compiler warnings in net/ipv4/route.c, as this 
> >> passes NULL as the first argument in the UP configuration. Simply 
> >> cast this.
> > 
> > Wondering - can the wrappers be moved from CPP land to C land by 
> > turning them into inlines? (i havent checked all usages so there 
> > might be some surprises, but by and large it ought to be 
> > possible.)
> 
> I thought about doing it that way. I decided not to because I 
> suspected it would be harder to verify that the behaviour is 
> unchanged.

These things break noisily if they are wrong so i wouldnt be worried 
about that aspect.

> Also the _lock_irqsave functions output to the flags parameter 
> (which isn't a pointer) so that has to remain a macro.

Do we still need it? I remember it was originally due to some 
sparc32-ness, but meanwhile that's fixed in Sparc so we can 
generally pass irq flags around at will.

> If you'd really rather an inline version, I can spend some time 
> looking into it.

Would be nice.

	Ingo
