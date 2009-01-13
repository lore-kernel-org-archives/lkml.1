Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbZAMSZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbZAMSZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZAMSZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:25:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33827 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbZAMSZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:25:20 -0500
Date: Tue, 13 Jan 2009 19:24:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Message-ID: <20090113182449.GA1718@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <20090113181222.GA24910@elte.hu> <alpine.LFD.2.00.0901131013580.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901131013580.6528@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 13 Jan 2009, Ingo Molnar wrote:
> >
> > And v8 is rock solid in all my testing - and i'll give v10 a similar 
> > workout as well.
> 
> The differences between v8 and v10 are very fundamental, since v8 does 
> the spinning inside the spinlock'ed loop (the spinning itself is not 
> inside the spinlock, but all the "real action" is).  So v8 not showing 
> problems doesn't really say much about v10 - totally different 
> algorithms that share only some of the support code.
> 
> So even if many lines look the same, those code-lines aren't the really 
> interesting ones. The only really interesting once is really the 
> atomic_cmpxchg (outside spinlock) vs atomic_xchg (inside spinlock), and 
> those are almost diametrically opposite.

yeah. What i thought they would be useful for are testing and experiments 
like this:

" what if you switch the spinning to more fair by typing this in your 
  current tree:

     git revert c10b491
"

... but that's a pretty narrow purpose.

> > Would you prefer a single commit or is this kind of delta development 
> > history useful, with all the variants (at least the later, more 
> > promising ones) included?
> 
> I'm not sure it makes sense to show the history here, especially as 
> there really were two different approaches, and while they share many 
> issues, they sure aren't equivalent nor are we really talking about any 
> evolution of the patch except in the sense of one being the kick-starter 
> for the alternative approach.
> 
> What _can_ make sense is to commit some of the infrastructure helper 
> code separately, ie the lock ownership and preemption changes, since 
> those really are independent of the spinning code, and at least the 
> preemption thing is interesting and relevant even without it.

ok, we'll improve the splitup.

	Ingo
