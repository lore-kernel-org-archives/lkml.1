Return-Path: <linux-kernel-owner+w=401wt.eu-S1765175AbZARIg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765175AbZARIg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 03:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZARIgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 03:36:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41194 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbZARIgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 03:36:49 -0500
Date: Sun, 18 Jan 2009 09:36:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] x86-64: Convert irqstacks to per-cpu
Message-ID: <20090118083637.GA21940@elte.hu>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232115396-26367-1-git-send-email-brgerst@gmail.com> <1232115396-26367-2-git-send-email-brgerst@gmail.com> <1232115396-26367-3-git-send-email-brgerst@gmail.com> <4972B6D9.4080101@kernel.org> <73c1f2160901172105p8ba1aa4v708e746d5548a79d@mail.gmail.com> <4972B967.4010606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4972B967.4010606@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> Brian Gerst wrote:
> >> Also, as pda field name, irqstackptr might be fine but wouldn't it be
> >> better to rename it to at least irq_stack_ptr as this change requires
> >> touching every users anyway?
> > 
> > I kept the same name unless it would conflict with something.  If you
> > want to rename it, it should be a separate patch.
> 
> Sure, that's an option too but it might as well be done when making 
> those percpu variables.  I don't really see why those two changes should 
> be separate.  There isn't any reason why they shouldn't be separate 
> either but if you're already mucking around every user...

yes, we should do the rename in this same patch as both patches have no 
impact on the actual kernel image. (sans source code line and string 
related deltas in the image.) Feel free to do the rename in his patch - 
that's the fastest way.

I'd suggest to rename from:

  DECLARE_PER_CPU(char, irqstack[IRQSTACKSIZE]);
  DECLARE_PER_CPU(char *, irqstackptr);

to:

  DECLARE_PER_CPU(char, irq_stack[IRQSTACKSIZE]);
  DECLARE_PER_CPU(char *, irq_stack_ptr);

In other cases, lets get Brian's patches in without further latencies so 
that we drain his pending-patches pipeline and get a consolidated base 
everyone can work from. Brian already had an unfortunate (and 
time-consuming) rebase/conflict-resolution pass due to us moving the 
percpu code from under him. We can do non-critical followups in separate 
delta patches.

	Ingo
