Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbYKWMiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbYKWMiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 07:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbYKWMiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 07:38:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54319 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbYKWMiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 07:38:09 -0500
Date: Sun, 23 Nov 2008 13:37:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
       arjan@infradead.org, srostedt@redhat.com
Subject: Re: [PATCH 4/4] trace: profile all if conditionals
Message-ID: <20081123123730.GI29663@elte.hu>
References: <20081121071213.365288293@goodmis.org> <20081121071328.462456268@goodmis.org> <20081121152030.7024971e.akpm@linux-foundation.org> <alpine.DEB.1.10.0811211832460.7797@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811211832460.7797@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Fri, 21 Nov 2008, Andrew Morton wrote:
> > >
> > > +#define if(cond) if (__builtin_constant_p((cond)) ? !!(cond) :		\
> > 
> > wheee...
> > 
> > Now how are you going to profile ?:, while, for(;expr;), etc? ;)

btw., there's hardware driven branch tracing and profiling in the 
works too, which captures all conditionals - including loops. Stay 
tuned :)

> I don't know. Give me a few months, I'll figure out a way ;-)

also loops generally have a more static (hence less interesting) 
prediction pattern - while for branches we frequently have a "should 
this branch be made likely/unlikely in the fastpath" question.

	Ingo
