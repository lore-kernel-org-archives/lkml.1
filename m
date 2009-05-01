Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbZEAQVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbZEAQVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZEAQVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:21:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51911 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbZEAQVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:21:08 -0400
Date: Fri, 1 May 2009 18:20:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter atomic
Message-ID: <20090501162053.GA17915@elte.hu>
References: <20090501022210.851418183@goodmis.org> <20090501022403.826182932@goodmis.org> <20090501115047.GA24706@elte.hu> <alpine.DEB.2.00.0905011016560.20374@gandalf.stny.rr.com> <alpine.DEB.2.00.0905011212130.20374@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905011212130.20374@gandalf.stny.rr.com>
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
> On Fri, 1 May 2009, Steven Rostedt wrote:
> 
> > 
> > On Fri, 1 May 2009, Ingo Molnar wrote:
> > 
> > > 
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > From: Steven Rostedt <srostedt@redhat.com>
> > > > 
> > > > The entries counter in cpu buffer is not atomic. Although it only 
> > > > gets updated by a single CPU, interrupts may come in and update 
> > > > the counter too. This would cause missing entries to be added.
> > > 
> > > > -	unsigned long			entries;
> > > > +	atomic_t			entries;
> > > 
> > > Hm, that's not really good as atomics can be rather expensive and 
> > > this is the fastpath.
> > 
> > Actually, it could be local_t. I used that in a lot of the other places.
> > The race is with on CPU not other CPUs, and on archs like x86 there
> > is not cost of the "LOCK".
> 
> Ug, it must be atomic_t. It is also modified by the reader. Thus 
> it is not only a race with a single CPU but also multiple CPUs.
> 
> This means that interrupts disabled is not the only proctection it 
> needs. It must either be an atomic, or protected by a spinlock.

Trace buffers are rather fundamentally per cpu. Where's the problem?

	Ingo
