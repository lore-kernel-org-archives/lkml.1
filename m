Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbZGRQLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbZGRQLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 12:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZGRQL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 12:11:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33035 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbZGRQL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 12:11:28 -0400
Date: Sat, 18 Jul 2009 18:10:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: wl12xx, fix lock imbalance
Message-ID: <20090718161029.GA16343@elte.hu>
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com> <1247521235.7178.1.camel@johannes.local> <4A5BAABF.9020708@gmail.com> <1247521789.7178.2.camel@johannes.local> <4A5BAC77.9010503@gmail.com> <1247522068.7178.4.camel@johannes.local> <20090718111948.GD27287@elte.hu> <1247916829.1055.24.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247916829.1055.24.camel@johannes.local>
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


* Johannes Berg <johannes@sipsolutions.net> wrote:

> > It would work like this: __acquires()/__releases() would also 
> > emit section markers like __lockfunc, and lockdep would warn 
> > about functions that return with unbalanced locks, irqs or 
> > preempt counts and do not declare themselves as locking related 
> > functions.
> > 
> > This would help catch imbalances at their source.
> 
> I don't see a need to do it dynamically since sparse warns about 
> things like this. It's quirky in some ways and I've tried to fix 
> it up before (and failed) but it's not something that can't be 
> fixed, it just needs more than a night of hacking.

Yeah - but Sparse warns about this if it can analyze the code path. 
If it cannot see through it then it cannot warn. Static analysis 
will go only that far - dynamic analysis will catch the cases that 
do happen.

So it's best to have both: static analysis is good at finding 
imbalances even if they have a very low likelyhood of occuring in 
practice, while dynamic analysis will catch everything that does 
trigger in practice, regardless of code flow complexity.

( The only white area on the map is rarely executed code that has a
  complex code flow. Such code is being frowned upon in general at 
  the review stage. )

> > Plus static tools like Jiri is working on are very useful as 
> > well. I think Coverty does that too and it's a pity we dont have 
> > free tools for that. In fact Covery will sweep clean the kernel 
> > of such bugs, giving OSS tools like 'stanse' the false 
> > impression that there are no such bugs. There are such bugs - 
> > there's a constant influx of them. So please work on this, it 
> > looks very useful.
> 
> What's "this" in this context?

this == stanse, the static code analyzing thing Jiri mentioned he is 
working on. The webpage says it will be under the GPL - that's good. 
Jiri, any release date for the source code?

	Ingo
