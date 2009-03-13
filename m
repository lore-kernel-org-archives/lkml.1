Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZCMKjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZCMKjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZCMKix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:38:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53215 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbZCMKiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:38:52 -0400
Date: Fri, 13 Mar 2009 11:38:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [tip:core/ipi] generic-ipi: eliminate spurious
	pointlessWARN_ON()s
Message-ID: <20090313103828.GB31094@elte.hu>
References: <49B91A7E.76E4.0078.0@novell.com> <tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org> <1236934491.5188.209.camel@laptop> <49BA33BE.76E4.0078.0@novell.com> <1236937423.22914.3698.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236937423.22914.3698.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-03-13 at 09:21 +0000, Jan Beulich wrote:
> > >>> Peter Zijlstra <peterz@infradead.org> 13.03.09 09:54 >>>
> > >Wouldn't leaving them in place but changing them to:
> > >
> > >WARN_ON(irqs_disabled() && system_state == SYSTEM_RUNNING);
> > >
> > >be clearer?
> > 
> > I don't think that would be precise: system_state gets set to
> > SYSTEM_RUNNING much later than APs get brought up (i.e. there are
> > cases where the WARN_ON()s could validly trigger with SYSTEM_BOOTING),
> > and also doesn't cover states > SYSTEM_RUNNING (where, again, after
> > perhaps having brought down all APs the warnings could become pointless,
> > but the warnings could be meaningful as long as there are still some APs
> > online).
> > 
> > While from an abstract code reading perspective your suggestion might
> > seem reasonable, the changed placement really reflects what the warning
> > is trying to warn about - a potential deadlock which cannot occur under
> > the conditions filtered out by conditionals the warnings were moved
> > beyond.
> 
> How about?
> 
> WARN_ON_ONCE(irqs_disabled() && !oops_in_progress)

ok, that's indeed better - i've done that - see the upcoming 
commit messages in this thread.

I also changed all of panic() to be covered by oops_in_progress 
- see the other commit. Eric: that should make kexec [a tiny 
bit] more robust too, agreed?

	Ingo
