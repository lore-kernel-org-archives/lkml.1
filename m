Return-Path: <linux-kernel-owner+w=401wt.eu-S1762423AbZCYSCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762423AbZCYSCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZCYSCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:02:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37560 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbZCYSCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:02:33 -0400
Date: Wed, 25 Mar 2009 19:02:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5][RFC] tracing: move function profiler data out of
	function struct
Message-ID: <20090325180203.GB25518@elte.hu>
References: <20090325035646.662994901@goodmis.org> <20090325040832.443420395@goodmis.org> <20090325100746.GI2341@elte.hu> <alpine.DEB.2.00.0903251142470.5675@gandalf.stny.rr.com> <20090325174446.GE14250@elte.hu> <alpine.DEB.2.00.0903251354020.5675@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903251354020.5675@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 25 Mar 2009, Ingo Molnar wrote:
> 
> > > The atomic_inc_return protects against NMIs, since this is the only place 
> > > the lock is taken.
> > 
> > i mean, if this code executes _ni_ an NMI. Or that cannot happen? We 
> > trace nmis too, dont we?
> 
> Yes, it can execute in an NMI, but we have no issues there. If the 
> lock was taken the atomic inc is set. If an NMI comes in, it will 
> fail the atomic inc counter test and never try to take the lock.

You are misunderstanding me. Can this bit:

> > +   if (!profile_pages->next && alloc_safe)
> > +           profile_pages->next = (void *)get_zeroed_page(GFP_ATOMIC);

run in NMI context?

or is alloc_safe false in that case? Even if it's safe it looks 
really messy ...

	Ingo
