Return-Path: <linux-kernel-owner+w=401wt.eu-S1752039AbZIBNHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbZIBNHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZIBNHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:07:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59308 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZIBNHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:07:49 -0400
Date: Wed, 2 Sep 2009 15:06:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: arjan@infradead.org, jeremy@goop.org, mschmidt@redhat.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] kthreads: Fix startup synchronization boot crash
Message-ID: <20090902130644.GA19528@elte.hu>
References: <tip-23386d63bbb3199cf247313ec088878d72debcfd@git.kernel.org> <20090901100351.GA3361@elte.hu> <20090901113914.GA23578@elte.hu> <20090901130436.GA22514@redhat.com> <20090901131440.GA29783@elte.hu> <20090901133709.GA24041@redhat.com> <20090901135925.GA9083@elte.hu> <20090901145526.GA31317@redhat.com> <20090901155427.GA18078@elte.hu> <20090901160043.GA6708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901160043.GA6708@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 09/01, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > But I must admit, now I don't understand what happens,
> > >
> > > 	The modification of that variable is protected by the BKL, but
> > > 	the _ordering_ of the initial task (which becomes the idle
> > > 	thread of CPU0) and the init task (which is spawned by the
> > > 	initial task) is not synchronized.
> > >
> > > 	So we can occasionally end up init running sooner than
> > > 	rest_init()
> > >
> > > How? rest_init() can't be preempted and it holds BKL. And
> > > kernel_init() takes BKL before anything else. Confused...
> >
> > it cannot be preempted but it can schedule anywhere - and the BKL
> > will be dropped silently.
> >
> > This is one of the biggest dangers of the BKL
> 
> Yes I see. But rest_init() runs under preempt_disable(). If it was 
> rescheduled, schedule_debug() should complain. No?

hm, either something is broken, or some other codepath learned to do 
preempt_enable() in early init ... [which i'd call broken too]

Weird.

	Ingo
